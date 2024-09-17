class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_signups_enabled, only: [:create]

  def create
    unless valid_invite_code?(params[:user][:invite_code])
      redirect_to root_path, alert: "Sign-ups are currently disabled or invalid invite code."
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
        UserMailer.welcome_email(resource).deliver_now
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
    @user.tags = @user.parsed_tags.join(', ')
  end

  def update
    @user = current_user
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)

    if sensitive_params_changed?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update_with_password(account_update_params)
          bypass_sign_in(@user)
          redirect_to edit_user_registration_path, notice: update_success_message
        else
          render :edit
        end
      else
        @user.errors.add(:current_password, "is required to change email, username, or password")
        render :edit
      end
    else
      params[:user].delete(:current_password)
      if @user.update(account_update_params)
        redirect_to edit_user_registration_path, notice: update_success_message
      else
        render :edit
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error updating user profile: #{e.message}\n#{e.backtrace.join("\n")}"
    @user.errors.add(:base, "An error occurred while updating your profile. Please try again.")
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