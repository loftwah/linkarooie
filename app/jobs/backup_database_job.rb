# app/jobs/backup_database_job.rb
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
  
      # Calculate backup file size before deleting it
      backup_size = File.size?(compressed_file)
      human_readable_size = human_readable_size(backup_size) # Convert size to human-readable format
  
      # Upload to DigitalOcean Spaces (URL not needed anymore)
      upload_to_spaces(compressed_file)
  
      # Optionally, delete the local backup files after upload
      File.delete(backup_file) if File.exist?(backup_file)
      File.delete(compressed_file) if File.exist?(compressed_file)
  
      Rails.logger.info "BackupDatabaseJob: Backup created, compressed, and uploaded successfully: #{compressed_file}"
  
      # Generate a report with human-readable size
      report = generate_backup_report(environment, compressed_file, "Success", nil, nil, human_readable_size)
  
      # Send an email with the report
      BackupReportMailer.backup_completed(report).deliver_now
    rescue => e
      Rails.logger.error "BackupDatabaseJob: Failed to create, compress, or upload backup: #{e.message}"
      
      # Generate a failure report
      report = generate_backup_report(environment, compressed_file, "Failed", nil, e.message)
  
      # Send an email with the failure report
      BackupReportMailer.backup_completed(report).deliver_now
      
      raise
    end
  end

  def generate_backup_report(environment, backup_file, status, backup_url = nil, error_message = nil, backup_size = nil)
    {
      environment: environment,
      timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      backup_file: backup_file,
      backup_url: backup_url,
      backup_size: backup_size || human_readable_size(File.size?(backup_file)),  # Use human-readable size
      status: status,
      error_message: error_message
    }
  end  

  private

  def human_readable_size(size)
    # Convert bytes to a human-readable format
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    return '0 B' if size == 0
    exp = (Math.log(size) / Math.log(1024)).to_i
    format('%.2f %s', size.to_f / (1024 ** exp), units[exp])
  end

  def upload_to_spaces(file_path)
    bucket_name = ENV['SPACES_BUCKET_NAME'] || 'sqlite-backup-bucket'
    file_name = File.basename(file_path)

    obj = S3_CLIENT.bucket(bucket_name).object("backups/#{file_name}")
    obj.upload_file(file_path)
  end
end
