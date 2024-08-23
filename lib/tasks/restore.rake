namespace :db do
  desc "Restore the SQLite database from a SQL dump"
  task restore: :environment do
    backup_file = ENV['BACKUP_FILE']

    unless backup_file
      puts "ERROR: You must provide the path to the backup file."
      puts "Usage: rake db:restore BACKUP_FILE=path/to/your_backup_file.sql[.tar.gz]"
      exit 1
    end

    begin
      # Check if the file is compressed
      if backup_file.end_with?('.tar.gz')
        # Extract the .sqlite3 file from the .tar.gz archive
        puts "Extracting #{backup_file}..."
        extracted_file = `tar -xzvf #{backup_file} -C db/backups`.strip
        extracted_file = "db/backups/#{extracted_file}"

        # Restore from the extracted .sqlite3 file
        restore_from_file(extracted_file)

        # Optionally, delete the extracted file after restoration
        File.delete(extracted_file) if File.exist?(extracted_file)
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

    # Drop the current database tables
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{ActiveRecord::Base.connection.tables.join(', ')}")

    # Load the backup SQL file
    system("sqlite3 #{Rails.configuration.database_configuration[Rails.env]['database']} < #{backup_file}")
  end
end
