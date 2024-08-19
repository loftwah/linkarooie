class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_page_views = current_user.page_views.count
    @total_link_clicks = current_user.link_clicks.count
    @total_achievement_views = current_user.achievement_views.count
    @unique_visitors = current_user.page_views.select(:ip_address).distinct.count

    @latest_daily_metric = current_user.daily_metrics.order(date: :desc).first

    @link_analytics = fetch_link_analytics
    @achievement_analytics = fetch_achievement_analytics
    @geographic_data = fetch_geographic_data
    @daily_views = fetch_daily_views
    @hourly_distribution = fetch_hourly_distribution
    @browser_data = fetch_browser_data
    @top_referrers = fetch_top_referrers
  end

  private

  def fetch_link_analytics
    current_user.links.includes(:link_clicks).map do |link|
      {
        id: link.id,
        title: link.title,
        total_clicks: link.link_clicks.count,
        unique_visitors: link.link_clicks.select(:ip_address).distinct.count,
        top_referrers: link.link_clicks.group(:referrer).count.sort_by { |_, v| -v }.take(5),
        browser_breakdown: link.link_clicks.group(:browser).count
      }
    end
  end

  def fetch_achievement_analytics
    current_user.achievements.includes(:achievement_views).map do |achievement|
      {
        id: achievement.id,
        title: achievement.title,
        total_views: achievement.achievement_views.count,
        unique_viewers: achievement.achievement_views.select(:ip_address).distinct.count
      }
    end
  end

  def fetch_geographic_data
    current_user.page_views.group(:ip_address).count.transform_keys do |ip|
      location = Geocoder.search(ip).first
      location ? "#{location.city}, #{location.country}" : "Unknown"
    end
  end

  def fetch_daily_views
    current_user.page_views.group_by_day(:visited_at, range: 30.days.ago..Time.now).count
  end

  def fetch_hourly_distribution
    current_user.page_views.group_by_hour_of_day(:visited_at).count
  end

  def fetch_browser_data
    current_user.page_views.group(:browser).count
  end

  def fetch_top_referrers
    current_user.page_views.group(:referrer).count.sort_by { |_, v| -v }.take(10)
  end
end