class PublicLinksController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show]  # Skip Devise's authentication for show action
  
    def show
      @public_links = Link.where(user_id: params[:user_id], public: true)
    end
  end
  