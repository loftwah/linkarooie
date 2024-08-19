class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_links, :track_click]

  def index
    @links = Link.order(:position)
  end

  def show
    @link = Link.find(params[:id])
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
    @links = @user.links.where(visible: true).order(:position)
    @pinned_links = @user.links.where(visible: true, pinned: true).order(:position)
    @achievements = @user.achievements.order(date: :desc)
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)
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
    params.require(:link).permit(:url, :title, :description, :position, :icon, :visible, :pinned)
  end
end