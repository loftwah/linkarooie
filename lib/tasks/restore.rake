namespace :db do
  desc "Restore the SQLite database from a SQL dump"
  task restore: :environment do
    backup_file = ENV['BACKUP_FILE']

    unless backup_file
      puts "ERROR: You must provide the path to the backup file."
      puts "Usage: rake db:restore BACKUP_FILE=path/to/your_backup_file.sql"
      exit 1
    end

    begin
      puts "Restoring database from #{backup_file}..."

      # Drop the current database tables
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{ActiveRecord::Base.connection.tables.join(', ')}")

      # Load the backup SQL file
      system("sqlite3 #{Rails.configuration.database_configuration[Rails.env]['database']} < #{backup_file}")

      puts "Database restored successfully."
    rescue => e
      puts "ERROR: Failed to restore the database: #{e.message}"
      exit 1
    end
  end
end
