class PublicLinksController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show]  # Skip Devise's authentication for show action
  
    def show
      @user = User.find_by!(username: params[:username])
      @public_links = Link.where(user_id: @user.id, public: true)
    end
  end
  