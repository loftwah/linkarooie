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

    if params[:user][:password].present? || params[:user][:password_confirmation].present?
      successfully_updated = @user.update_with_password(account_update_params)
    else
      params[:user].delete(:current_password)
      successfully_updated = @user.update_without_password(account_update_params.except(:current_password))
    end

    if successfully_updated
      redirect_to edit_user_registration_path, notice: 'Profile updated successfully'
    else
      render :edit
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name, :tags, :avatar, :banner, :description).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :full_name, :tags, :avatar, :banner, :description).tap do |user_params|
      user_params[:tags] = user_params[:tags].split(',').map(&:strip).to_json if user_params[:tags].present?
    end
  end
end
