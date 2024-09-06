# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def index
    @users = User.all
  end
end
