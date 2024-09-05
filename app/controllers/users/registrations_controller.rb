class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_signups_enabled, only: [:create]

  def create
    # Check if sign-ups are disabled and no valid invite code is provided
    unless Rails.application.config.sign_ups_open || valid_invite_code?(params[:user][:invite_code])
      redirect_to root_path, alert: "Sign-ups are currently disabled."
      return
    end

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

    is_password_change = params[:user][:password].present? || params[:user][:password_confirmation].present?
    is_email_change = params[:user][:email].present? && params[:user][:email] != @user.email

    if is_password_change || is_email_change
      successfully_updated = @user.update_with_password(account_update_params)
    else
      params[:user].delete(:current_password)
      successfully_updated = @user.update_without_password(account_update_params)
    end

    if successfully_updated
      bypass_sign_in(@user)
      redirect_to edit_user_registration_path, notice: 'Profile updated successfully'
    else
      render :edit
    end
  end

  private

  def check_signups_enabled
    # Check if sign-ups are disabled and no valid invite code is provided
    if !Rails.application.config.sign_ups_open && (params[:user].blank? || !valid_invite_code?(params[:user][:invite_code]))
      redirect_to root_path, alert: "Sign-ups are currently disabled."
    end
  end

  def valid_invite_code?(invite_code)
    # List of valid invite codes
    valid_codes = ["POWEROVERWHELMING", "SWORDFISH", "HUNTER2"]
  
    # Check if the provided invite code matches any of the valid codes, case-insensitive
    valid_codes.any? { |code| code.casecmp(invite_code).zero? }
  end  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :avatar_border, :invite_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :avatar_border])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :avatar_border, :invite_code).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :public_analytics, :avatar_border).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end
end
