class UserMailer < ApplicationMailer
  default from: 'loftwah@linkarooie.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://linkarooie.com/login'
    mail(to: @user.email, subject: 'Welcome to Linkarooie!')
  end
end
