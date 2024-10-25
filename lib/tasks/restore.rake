namespace :db do
  desc "Restore the SQLite database from a SQL dump"
  task restore: :environment do
    backup_file = ENV['BACKUP_FILE']

    unless backup_file
      puts "ERROR: You must provide the path to the backup file."
      puts "Usage: rake db:restore BACKUP_FILE=path/to/your_backup_file.sql[.tar.gz]"
      exit 1
    end

    unless File.exist?(backup_file)
      puts "ERROR: Backup file not found: #{backup_file}"
      exit 1
    end

    begin
      # Check if the file is compressed
      if backup_file.end_with?('.tar.gz')
        # Extract the .sqlite3 file from the .tar.gz archive
        puts "Extracting #{backup_file}..."
        extracted_file = `tar -xzvf #{backup_file} -C /rails/storage`.lines.first&.strip

        # Handle the case where the extraction fails
        if extracted_file.nil? || extracted_file.empty?
          raise "File extraction failed: #{backup_file}"
        end

        extracted_file_path = "/rails/storage/#{extracted_file}"

        # Restore from the extracted .sqlite3 file
        restore_from_file(extracted_file_path)

        # Optionally, delete the extracted file after restoration
        File.delete(extracted_file_path) if File.exist?(extracted_file_path)
      else
        # Restore from the uncompressed .sqlite3 file
        restore_from_file(backup_file)
      end

      puts "Database restored successfully."
    rescue => e
      puts "ERROR: Failed to restore the database: #{e.message}"
      exit 1
    end
  end

  def restore_from_file(backup_file)
    puts "Restoring database from #{backup_file}..."

    # Disable foreign key checks
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF;")

    # Drop each table individually
    ActiveRecord::Base.connection.tables.each do |table|
      next if ['schema_migrations', 'ar_internal_metadata'].include?(table)
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table}")
    end

    # Restore the backup into the database
    system("sqlite3 #{Rails.configuration.database_configuration[Rails.env]['database']} < #{backup_file}")

    # Re-enable foreign key checks
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON;")
  end  
end
