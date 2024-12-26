# app/services/backup_cleanup_service.rb
class BackupCleanupService
  def initialize(retention_days: 30)
    @retention_days = retention_days
    @spaces_service = DigitalOceanSpacesService.new
  end

  def cleanup
    cutoff_date = Time.now - @retention_days.days
    deleted_count = 0
    errors = []

    begin
      # List all backup objects in the bucket
      bucket = S3_CLIENT.bucket(ENV['SPACES_BUCKET_NAME'])
      bucket.objects(prefix: 'backups/').each do |object|
        begin
          # Parse the timestamp from the backup filename
          # Expects format: environment_backup_YYYYMMDDHHMMSS.tar.gz
          timestamp_str = object.key.match(/(\d{14})\.tar\.gz$/)&.[](1)
          next unless timestamp_str

          timestamp = Time.strptime(timestamp_str, '%Y%m%d%H%M%S')

          if timestamp < cutoff_date
            object.delete
            deleted_count += 1
            Rails.logger.info "Deleted old backup: #{object.key}"
          end
        rescue StandardError => e
          errors << { key: object.key, error: e.message }
          Rails.logger.error "Error processing backup #{object.key}: #{e.message}"
        end
      end

      # Generate report
      {
        status: errors.empty? ? 'success' : 'partial_success',
        deleted_count: deleted_count,
        retention_days: @retention_days,
        errors: errors,
        timestamp: Time.current
      }
    rescue StandardError => e
      Rails.logger.error "Critical error in backup cleanup: #{e.message}"
      {
        status: 'failed',
        error: e.message,
        timestamp: Time.current
      }
    end
  end
end