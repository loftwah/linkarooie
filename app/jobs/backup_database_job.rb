class BackupDatabaseJob < ApplicationJob
  queue_as :default

  def perform
    environment = Rails.env
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    backup_file = "db/backups/#{environment}_backup_#{timestamp}.sqlite3"
    compressed_file = "db/backups/#{environment}_backup_#{timestamp}.tar.gz"

    begin
      # Ensure the backup directory exists
      FileUtils.mkdir_p("db/backups")

      # Dump the SQLite database for the current environment
      database_path = Rails.configuration.database_configuration[environment]["database"]
      `sqlite3 #{database_path} .dump > #{backup_file}`

      # Compress the backup file
      `tar -czf #{compressed_file} -C db/backups #{File.basename(backup_file)}`

      # Upload to DigitalOcean Spaces
      upload_to_spaces(compressed_file)

      # Optionally, delete the local backup files after upload
      File.delete(backup_file) if File.exist?(backup_file)
      File.delete(compressed_file) if File.exist?(compressed_file)

      Rails.logger.info "BackupDatabaseJob: Backup created, compressed, and uploaded successfully: #{compressed_file}"
    rescue => e
      Rails.logger.error "BackupDatabaseJob: Failed to create, compress, or upload backup: #{e.message}"
      raise
    end
  end

  private

  def upload_to_spaces(file_path)
    bucket_name = ENV['SPACES_BUCKET_NAME'] || 'sqlite-backup-bucket'
    file_name = File.basename(file_path)

    obj = S3_CLIENT.bucket(bucket_name).object("backups/#{file_name}")
    obj.upload_file(file_path)
  end
end
