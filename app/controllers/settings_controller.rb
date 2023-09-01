class SettingsController < ApplicationController
    before_action :authenticate_user!
  
    def edit
      @user = current_user
    end
  
    def update
      @user = current_user
      if @user.update(settings_params)
        redirect_to edit_settings_path, notice: 'Settings updated successfully.'
      else
        render :edit
      end
    end
  
    private
  
    def settings_params
      params.require(:user).permit(:username, :first_name, :last_name, :short_description, :tags)
    end
  end
  