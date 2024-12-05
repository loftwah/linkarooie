class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_signups_enabled, only: [:create]

  def create
    unless valid_invite_code?(params[:user][:invite_code])
      redirect_to root_path, alert: "Sign-ups are currently disabled or invalid invite code."
      return
    end

    build_resource(sign_up_params)
    resource.tags = ['linkarooie'].to_json if resource.tags.blank?
    resource.tags = JSON.parse(resource.tags) if resource.tags.is_a?(String)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        begin
          UserMailer.welcome_email(resource).deliver_later
        rescue => e
          Rails.logger.error("Failed to enqueue welcome email for user #{resource.id}: #{e.message}")
        end
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
  rescue => e
    Rails.logger.error("Error during user registration: #{e.message}")
    flash[:error] = "An error occurred during registration. Please try again."
    redirect_to new_user_registration_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  
    # Convert comma-separated tags into an array
    if params[:user][:tags].present?
      Rails.logger.info "Processing tags: #{params[:user][:tags]}"
      @user.tags = params[:user][:tags].split(',').map(&:strip)
      Rails.logger.info "Tags after splitting: #{@user.tags.inspect}"
    end
  
    # Log user state before save
    Rails.logger.info "User object before save: #{@user.inspect}"
  
    # Handle sensitive and non-sensitive updates
    if sensitive_params_changed?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update_with_password(account_update_params)
          bypass_sign_in(@user)
          Rails.logger.info "User successfully updated with sensitive params: #{@user.inspect}"
          redirect_to edit_user_registration_path, notice: update_success_message
        else
          Rails.logger.error "User update failed: #{@user.errors.full_messages.join(', ')}"
          render :edit
        end
      else
        Rails.logger.error "Invalid current password for sensitive update"
        @user.errors.add(:current_password, "is required to change email, username, or password")
        render :edit
      end
    else
      params[:user].delete(:current_password)
  
      if @user.update(account_update_params.except(:password, :password_confirmation))
        Rails.logger.info "User successfully updated with non-sensitive params: #{@user.inspect}"
        redirect_to edit_user_registration_path, notice: update_success_message
      else
        Rails.logger.error "User update failed: #{@user.errors.full_messages.join(', ')}"
        render :edit
      end
    end
  rescue => e
    Rails.logger.error("Error during user update: #{e.message}")
    flash[:error] = "An error occurred while updating your profile. Please try again."
    render :edit
  end  

  private

  def check_signups_enabled
    unless valid_invite_code?(params[:user][:invite_code])
      redirect_to root_path, alert: "Sign-ups are currently disabled or invalid invite code."
    end
  end

  def valid_invite_code?(invite_code)
    valid_codes = ["POWEROVERWHELMING", "SWORDFISH", "HUNTER2"]
    valid_codes.any? { |code| code.casecmp(invite_code.to_s).zero? }
  end

  def sensitive_params_changed?
    params[:user][:password].present? ||
    params[:user][:email] != @user.email ||
    params[:user][:username] != @user.username
  end

  def update_success_message
    if @user.previous_changes.key?('avatar') || @user.previous_changes.key?('banner')
      'Profile updated successfully. Image processing may take a few moments.'
    else
      'Profile updated successfully.'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :avatar_border, :invite_code, :community_opt_in])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :public_analytics, :avatar_border, :community_opt_in])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :avatar_border, :invite_code, :community_opt_in).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :full_name, :tags, :avatar, :banner, :description, :banner_enabled, :public_analytics, :avatar_border, :community_opt_in).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end
end