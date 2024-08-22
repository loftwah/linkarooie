class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_page_views = Rails.cache.fetch("#{cache_key_with_version}/total_page_views", expires_in: 10.minutes) do
      current_user.page_views.count
    end

    @total_link_clicks = Rails.cache.fetch("#{cache_key_with_version}/total_link_clicks", expires_in: 10.minutes) do
      current_user.link_clicks.count
    end

    @total_achievement_views = Rails.cache.fetch("#{cache_key_with_version}/total_achievement_views", expires_in: 10.minutes) do
      current_user.achievement_views.count
    end

    @unique_visitors = Rails.cache.fetch("#{cache_key_with_version}/unique_visitors", expires_in: 10.minutes) do
      current_user.page_views.select(:ip_address).distinct.count
    end

    @latest_daily_metric = Rails.cache.fetch("#{cache_key_with_version}/latest_daily_metric", expires_in: 10.minutes) do
      current_user.daily_metrics.order(date: :desc).first
    end

    @link_analytics = Rails.cache.fetch("#{cache_key_with_version}/link_analytics", expires_in: 10.minutes) { fetch_link_analytics }
    @achievement_analytics = Rails.cache.fetch("#{cache_key_with_version}/achievement_analytics", expires_in: 10.minutes) { fetch_achievement_analytics }
    @geographic_data = Rails.cache.fetch("#{cache_key_with_version}/geographic_data", expires_in: 10.minutes) { fetch_geographic_data }
    @daily_views = Rails.cache.fetch("#{cache_key_with_version}/daily_views", expires_in: 10.minutes) { fetch_daily_views }
    @hourly_distribution = Rails.cache.fetch("#{cache_key_with_version}/hourly_distribution", expires_in: 10.minutes) { fetch_hourly_distribution }
    @browser_data = Rails.cache.fetch("#{cache_key_with_version}/browser_data", expires_in: 10.minutes) { fetch_browser_data }
    @top_referrers = Rails.cache.fetch("#{cache_key_with_version}/top_referrers", expires_in: 10.minutes) { fetch_top_referrers }
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
    current_user.page_views.group(:browser).count.transform_keys do |user_agent|
      case user_agent
      when /Chrome/
        'Chrome'
      when /Firefox/
        'Firefox'
      when /Safari/
        'Safari'
      when /Edge/
        'Edge'
      when /IE/
        'Internet Explorer'
      else
        'Other'
      end
    end
  end  

  def fetch_top_referrers
    current_user.page_views.group(:referrer).count.sort_by { |_, v| -v }.take(10)
  end

  def cache_key_with_version
    "user_#{current_user.id}_analytics_v1"
  end
end
