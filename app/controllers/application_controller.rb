# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_global_user
  
  private
  
  def set_global_user
    @user = current_user if user_signed_in?
  end
end
