namespace :db do
  desc "Restore the SQLite database from Spaces backup"
  task restore: :environment do
    backup_file = ENV['BACKUP_FILE']

    unless backup_file
      puts "ERROR: You must provide the backup file name."
      puts "Usage: rake db:restore BACKUP_FILE=production_backup_20241025020000.tar.gz"
      exit 1
    end

    begin
      # Create backups directory if it doesn't exist
      FileUtils.mkdir_p("db/backups")
      local_file = "db/backups/#{backup_file}"

      # Download from Spaces
      puts "Downloading backup from Spaces..."
      bucket_name = ENV['SPACES_BUCKET_NAME']
      S3_CLIENT.bucket(bucket_name).object("backups/#{backup_file}").download_file(local_file)

      if backup_file.end_with?('.tar.gz')
        puts "Extracting #{backup_file}..."
        extracted_file = `tar -xzvf #{local_file} -C db/backups`.strip
        extracted_file = "db/backups/#{extracted_file}"

        restore_from_file(extracted_file)

        File.delete(extracted_file) if File.exist?(extracted_file)
      else
        restore_from_file(local_file)
      end

      # Clean up
      File.delete(local_file) if File.exist?(local_file)
      puts "Database restored successfully."
    rescue => e
      puts "ERROR: Failed to restore the database: #{e.message}"
      exit 1
    end
  end

  def restore_from_file(backup_file)
    puts "Restoring database from #{backup_file}..."
    database_path = Rails.configuration.database_configuration[Rails.env]['database']
    
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{ActiveRecord::Base.connection.tables.join(', ')}")
    system("sqlite3 #{database_path} < #{backup_file}")
  end
end