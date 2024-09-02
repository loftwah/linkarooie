class UserMailer < ApplicationMailer
  default from: 'loftwah@linkarooie.com'

  def welcome_email(user)
    @user = user
    @url = 'https://linkarooie.com/users/sign_in' # Directly use the login URL
    mail(to: @user.email, subject: 'Welcome to Linkarooie!')
  end
end
