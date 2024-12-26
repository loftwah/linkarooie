# app/mailers/backup_report_mailer.rb
class BackupReportMailer < ApplicationMailer
  default from: 'loftwah@linkarooie.com', to: 'dean+linkarooie@deanlofts.xyz'

  def backup_completed(report)
    @report = report
    mail(subject: 'Linkarooie - Backup Completed Successfully')
  end

  def cleanup_report(result)
    @result = result
    mail(subject: 'Linkarooie - Backup Cleanup Report')
  end
  
  def cleanup_failed(result)
    @result = result
    mail(subject: 'Linkarooie - Backup Cleanup Failed')
  end
end
