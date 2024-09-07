class UsersController < ApplicationController
  def index
    # Only fetch users who have opted into community features
    @users = User.where(community_opt_in: true)
  end
end
