class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    build_resource(sign_up_params)

    resource.tags = JSON.parse(resource.tags) if resource.tags.is_a?(String)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        UserMailer.welcome_email(resource).deliver_now  # Send the welcome email
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    @user = current_user
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)
  end

  def update
    @user = current_user
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)
  
    # Check if password or email is being updated
    is_password_change = params[:user][:password].present? || params[:user][:password_confirmation].present?
    is_email_change = params[:user][:email].present? && params[:user][:email] != @user.email
  
    if is_password_change || is_email_change
      # Require current password for sensitive changes
      successfully_updated = @user.update_with_password(account_update_params)
    else
      # Do not require current password for non-sensitive changes
      params[:user].delete(:current_password)
      successfully_updated = @user.update_without_password(account_update_params)
    end
  
    if successfully_updated
      bypass_sign_in(@user) # Sign in the user bypassing validation
      redirect_to edit_user_registration_path, notice: 'Profile updated successfully'
    else
      render :edit
    end
  end  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :public_analytics).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end
end