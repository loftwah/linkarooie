# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @user = current_user if user_signed_in?
  end
end
