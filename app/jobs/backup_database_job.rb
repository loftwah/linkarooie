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
  
      # Upload to DigitalOcean Spaces and get the signed URL
      backup_url = upload_to_spaces(compressed_file)
  
      # Optionally, delete the local backup files after upload
      File.delete(backup_file) if File.exist?(backup_file)
      File.delete(compressed_file) if File.exist?(compressed_file)
  
      Rails.logger.info "BackupDatabaseJob: Backup created, compressed, and uploaded successfully: #{compressed_file}"
  
      # Generate a report with the backup size
      report = generate_backup_report(environment, compressed_file, "Success", backup_url, nil, backup_size)
  
      # Send an email with the report
      BackupReportMailer.backup_completed(report).deliver_now
    rescue => e
      Rails.logger.error "BackupDatabaseJob: Failed to create, compress, or upload backup: #{e.message}"
      
      # Generate a failure report without URL
      report = generate_backup_report(environment, compressed_file, "Failed", nil, e.message)
  
      # Send an email with the failure report
      BackupReportMailer.backup_completed(report).deliver_now
      
      raise
    end
  end
  
  # Updated generate_backup_report to accept backup_size as a parameter
  def generate_backup_report(environment, backup_file, status, backup_url = nil, error_message = nil, backup_size = nil)
    {
      environment: environment,
      timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      backup_file: backup_file,
      backup_url: backup_url,
      backup_size: backup_size || File.size?(backup_file),  # Fallback if size wasn't passed
      status: status,
      error_message: error_message
    }
  end  

  private

  def upload_to_spaces(file_path)
    bucket_name = ENV['SPACES_BUCKET_NAME'] || 'sqlite-backup-bucket'
    file_name = File.basename(file_path)

    obj = S3_CLIENT.bucket(bucket_name).object("backups/#{file_name}")
    obj.upload_file(file_path)

    # Generate a signed URL that expires in 24 hours
    signed_url = obj.presigned_url(:get, expires_in: 24 * 60 * 60)

    signed_url
  end
end
