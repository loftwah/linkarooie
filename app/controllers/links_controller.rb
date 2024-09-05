class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_links, :track_click]
  before_action :set_theme, only: [:user_links]

  def index
    # Scope links to the current user
    @links = current_user.links.order(:position)
  end

  def show
    @link = current_user.links.find(params[:id])
  end

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)
    if @link.save
      redirect_to @link, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  def edit
    @link = current_user.links.find(params[:id])
  end

  def update
    @link = current_user.links.find(params[:id])
    if @link.update(link_params)
      redirect_to @link, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  def user_links
    @user = User.find_by(username: params[:username])
    return redirect_to root_path, alert: "User not found" if @user.nil?

    @links = @user.links.visible
    @hidden_links = @user.links.hidden
    @pinned_links = @user.links.pinned
    @achievements = @user.achievements
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)

    # Add debugging
    Rails.logger.debug "Theme: #{@theme.inspect}"
    Rails.logger.debug "Hidden Links: #{@hidden_links.inspect}"

    # Render the appropriate template based on the theme
    case @theme
    when 'retro'
      render 'user_links_retro'
    when 'win95'
      render 'user_links_win95'
    when 'win98'
      render 'user_links_win98'
    else
      render 'user_links'
    end
  end

  def track_click
    @link = Link.find(params[:id])
    LinkClick.create(
      link: @link,
      user: @link.user,
      clicked_at: Time.current,
      referrer: request.referrer,
      browser: request.user_agent,
      ip_address: request.ip,
      session_id: request.session.id
    )
    redirect_to @link.url, allow_other_host: true
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :description, :position, :icon, :visible, :pinned, :hidden)
  end

  def set_theme
    @theme = params[:theme] || 'default'
  end
end
