# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @user = current_user if user_signed_in?
    @links = Link.where(user: @user, links_enabled: true).order(:links_group, :links_pinned)
  end
end
