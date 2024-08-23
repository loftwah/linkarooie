class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_page_views = Rails.cache.fetch("#{cache_key_with_version}/total_page_views", expires_in: CACHE_EXPIRATION) do
      current_user.page_views.count
    end

    @total_link_clicks = Rails.cache.fetch("#{cache_key_with_version}/total_link_clicks", expires_in: CACHE_EXPIRATION) do
      current_user.link_clicks.count
    end

    @total_achievement_views = Rails.cache.fetch("#{cache_key_with_version}/total_achievement_views", expires_in: CACHE_EXPIRATION) do
      current_user.achievement_views.count
    end

    @unique_visitors = Rails.cache.fetch("#{cache_key_with_version}/unique_visitors", expires_in: CACHE_EXPIRATION) do
      current_user.page_views.select(:ip_address).distinct.count
    end

    @latest_daily_metric = Rails.cache.fetch("#{cache_key_with_version}/latest_daily_metric", expires_in: CACHE_EXPIRATION) do
      current_user.daily_metrics.order(date: :desc).first
    end

    @link_analytics = Rails.cache.fetch("#{cache_key_with_version}/link_analytics", expires_in: CACHE_EXPIRATION) { fetch_link_analytics }
    @achievement_analytics = Rails.cache.fetch("#{cache_key_with_version}/achievement_analytics", expires_in: CACHE_EXPIRATION) { fetch_achievement_analytics }
    @geographic_data = Rails.cache.fetch("#{cache_key_with_version}/geographic_data", expires_in: CACHE_EXPIRATION) { fetch_geographic_data }
    @daily_views = Rails.cache.fetch("#{cache_key_with_version}/daily_views", expires_in: CACHE_EXPIRATION) { fetch_daily_views }
    @hourly_distribution = Rails.cache.fetch("#{cache_key_with_version}/hourly_distribution", expires_in: CACHE_EXPIRATION) { fetch_hourly_distribution }
    @browser_data = Rails.cache.fetch("#{cache_key_with_version}/browser_data", expires_in: CACHE_EXPIRATION) { fetch_browser_data }
    @top_referrers = Rails.cache.fetch("#{cache_key_with_version}/top_referrers", expires_in: CACHE_EXPIRATION) { fetch_top_referrers }
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

  def fetch_top_referrers
    referrers = current_user.page_views.group(:referrer).count

    # Normalize referrers to group similar ones together
    normalized_referrers = referrers.each_with_object(Hash.new(0)) do |(referrer, count), hash|
      normalized_referrer = normalize_referrer(referrer)
      hash[normalized_referrer] += count
    end

    normalized_referrers.sort_by { |_, v| -v }.take(10)
  end

  def normalize_referrer(referrer)
    return 'Direct' if referrer.blank?
    
    uri = URI.parse(referrer)
    host = uri.host.downcase
  
    # Remove 'www.' prefix for consistency
    host = host.start_with?('www.') ? host[4..-1] : host
  
    # Normalize common referrers
    case host
    when 't.co'
      'Twitter'
    when 'facebook.com', 'fb.com'
      'Facebook'
    when 'instagram.com'
      'Instagram'
    when 'linkedin.com'
      'LinkedIn'
    when 'pinterest.com'
      'Pinterest'
    when 'youtube.com', 'youtu.be'
      'YouTube'
    when 'reddit.com'
      'Reddit'
    when 'tumblr.com'
      'Tumblr'
    when 'snapchat.com'
      'Snapchat'
    when 'whatsapp.com'
      'WhatsApp'
    when 'telegram.org'
      'Telegram'
    when 'discord.com', 'discordapp.com'
      'Discord'
    when 'google.com', 'google.co.uk', 'google.fr', 'google.de', 'google.es', 
         'google.it', 'google.ca', 'google.com.au', 'google.co.in', 'google.co.jp'
      'Google'
    when 'bing.com'
      'Bing'
    when 'yahoo.com', 'yahoo.co.jp'
      'Yahoo'
    when 'duckduckgo.com'
      'DuckDuckGo'
    when 'baidu.com'
      'Baidu'
    when 'yandex.com', 'yandex.ru'
      'Yandex'
    when 'amazon.com', 'amazon.co.uk', 'amazon.de', 'amazon.fr', 'amazon.co.jp'
      'Amazon'
    when 'ebay.com', 'ebay.co.uk'
      'eBay'
    when 'quora.com'
      'Quora'
    when 'medium.com'
      'Medium'
    when 'wikipedia.org'
      'Wikipedia'
    else
      host.capitalize # Default to capitalized host if not matched
    end
  rescue URI::InvalidURIError
    'Unknown'
  end  

  def cache_key_with_version
    "user_#{current_user.id}_analytics_v1"
  end
end
