# app/jobs/cleanup_old_backups_job.rb
class CleanupOldBackupsJob < ApplicationJob
  queue_as :default

  def perform
    service = BackupCleanupService.new
    result = service.cleanup

    # Send report email if configured
    if result[:status] == 'failed'
      BackupReportMailer.cleanup_failed(result).deliver_later
    elsif result[:deleted_count] > 0 || result[:errors].any?
      BackupReportMailer.cleanup_report(result).deliver_later
    end

    # Log the results
    if result[:status] == 'success'
      Rails.logger.info "Successfully cleaned up #{result[:deleted_count]} old backups"
    else
      Rails.logger.warn "Backup cleanup completed with issues. Status: #{result[:status]}"
    end
  end
end