class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_links]

  def index
    @links = current_user.links.order(:position)
  end

  def show
    @link = Link.find(params[:id])

    # Track the link click/view (only for normal view, not edit or update)
    unless request.referer&.include?('edit') || request.patch? || request.put?
      LinkClick.create(
        link: @link,
        user: @link.user,
        clicked_at: Time.current,
        referrer: request.referrer,
        browser: request.user_agent,
        ip_address: request.ip,
        session_id: request.session.id
      )
    end

    # If there's a URL present and this is a regular view, redirect to it
    if @link.url.present? && !request.referer&.include?('edit') && !request.patch?
      redirect_to @link.url, allow_other_host: true
    else
      # Otherwise render the link details
      render :show
    end
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
      # After updating, redirect to the show page, not the URL
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

    @links = @user.links.visible.order(:position)
    @hidden_links = @user.links.hidden.order(:position)
    @pinned_links = @user.links.pinned.order(:position)
    @achievements = @user.achievements.order(date: :desc)
    @user.tags = JSON.parse(@user.tags) if @user.tags.is_a?(String)

    # This was restored: logging hidden links in the browser console
    Rails.logger.debug "Hidden Links: #{@hidden_links.inspect}"

    case params[:theme]
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

  private

  def link_params
    params.require(:link).permit(:url, :title, :description, :position, :icon, :visible, :pinned, :hidden)
  end
end
