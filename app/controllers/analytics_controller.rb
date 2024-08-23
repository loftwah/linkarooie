class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_page_views = fetch_cached_data("total_page_views") { current_user.page_views.count }
    @total_link_clicks = fetch_cached_data("total_link_clicks") { current_user.link_clicks.count }
    @total_achievement_views = fetch_cached_data("total_achievement_views") { current_user.achievement_views.count }
    @unique_visitors = fetch_cached_data("unique_visitors") { current_user.page_views.select(:ip_address).distinct.count }
    @latest_daily_metric = fetch_cached_data("latest_daily_metric") { current_user.daily_metrics.order(date: :desc).first }
    @link_analytics = fetch_cached_data("link_analytics") { fetch_link_analytics }
    @achievement_analytics = fetch_cached_data("achievement_analytics") { fetch_achievement_analytics }
    @daily_views = fetch_cached_data("daily_views") { fetch_daily_views }
    @browser_data = fetch_cached_data("browser_data") { fetch_browser_data }
  end

  private

  def fetch_cached_data(key, &block)
    Rails.cache.fetch("#{cache_key_with_version}/#{key}", expires_in: CACHE_EXPIRATION, &block)
  end

  def fetch_link_analytics
    current_user.links.includes(:link_clicks).map do |link|
      {
        id: link.id,
        title: link.title,
        total_clicks: link.link_clicks.count,
        unique_visitors: link.link_clicks.select(:ip_address).distinct.count
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

  def fetch_daily_views
    current_user.page_views.group_by_day(:visited_at, range: 30.days.ago..Time.now).count
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
      when /Opera/
        'Opera'
      when /Brave/
        'Brave'
      when /Vivaldi/
        'Vivaldi'
      when /DuckDuckGo/
        'DuckDuckGo'
      when /IE|Internet Explorer/
        'Internet Explorer'
      when /OpenAI/
        'OpenAI Bot'
      when /Googlebot/
        'Googlebot'
      when /Bingbot/
        'Bingbot'
      when /Slurp/
        'Yahoo! Slurp'
      when /DuckDuckBot/
        'DuckDuckBot'
      when /Baiduspider/
        'Baiduspider'
      else
        'Other'
      end
    end
  end  

  def cache_key_with_version
    "user_#{current_user.id}_analytics_v1"
  end
end