# app/mailers/backup_report_mailer.rb
class BackupReportMailer < ApplicationMailer
  default from: 'loftwah@linkarooie.com', to: 'dean+linkarooie@deanlofts.xyz'

  def backup_completed(report)
    @report = report
    mail(subject: 'Backup Completed Successfully')
  end
end
