class AchievementsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    @achievements = current_user.achievements.order(date: :desc)
  end

  def show
    @achievement = Achievement.find(params[:id])

    # Track the achievement view (only for normal view, not edit or update)
    unless request.referer&.include?('edit') || request.patch? || request.put?
      AchievementView.create(
        achievement: @achievement,
        user: @achievement.user,
        viewed_at: Time.current,
        referrer: request.referrer,
        browser: request.user_agent,
        ip_address: request.ip,
        session_id: request.session.id
      )
    end

    # If there's a URL present and this is a regular view, redirect to it
    if @achievement.url.present? && !request.referer&.include?('edit') && !request.patch?
      redirect_to @achievement.url, allow_other_host: true
    else
      render :show
    end
  end

  def new
    @achievement = current_user.achievements.build
  end

  def create
    @achievement = current_user.achievements.build(achievement_params)
    if @achievement.save
      redirect_to achievements_path, notice: 'Achievement was successfully created.'
    else
      render :new
    end
  end

  def edit
    @achievement = current_user.achievements.find(params[:id])
  end

  def update
    @achievement = current_user.achievements.find(params[:id])
    if @achievement.update(achievement_params)
      redirect_to achievements_path, notice: 'Achievement was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @achievement = current_user.achievements.find(params[:id])
    @achievement.destroy
    redirect_to achievements_url, notice: 'Achievement was successfully destroyed.'
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :date, :description, :icon, :url)
  end
end
