# app/jobs/send_waiting_list_report_job.rb
class SendWaitingListReportJob < ApplicationJob
  queue_as :default

  def perform
    WaitingListMailer.daily_report('dean@deanlofts.xyz').deliver_now
  end
end