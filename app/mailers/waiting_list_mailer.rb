# app/mailers/waiting_list_mailer.rb
class WaitingListMailer < ApplicationMailer
  default from: 'loftwah@linkarooie.com'

  def daily_report(email)
    @waiting_list = WaitingList.all
    @total_count = @waiting_list.count
    @today_count = @waiting_list.where('created_at >= ?', Time.zone.now.beginning_of_day).count
    @url = 'https://linkarooie.com'
    
    mail(to: email, subject: 'Linkarooie - Daily Waiting List Report')
  end
end