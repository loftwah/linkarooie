module ApplicationHelper
  def auto_link_urls(text)
    text.gsub(%r{(https?://[^\s]+)}) do |url|
      "<a href='#{url}' target='_blank' class='text-lime-300 hover:underline'>#{url}</a>"
    end.html_safe
  end

  def avatar_border_class(border_preference)
    case border_preference
    when 'white'
      'border-4 border-white'
    when 'black'
      'border-4 border-black'
    when 'rainbow'
      'border-4 border-transparent avatar-rainbow-border'
    when 'rainbow-overlay'
      'avatar-rainbow-overlay'
    else
      ''
    end
  end

  def format_referrer(referrer)
    return 'Direct' if referrer.blank?

    begin
      uri = URI.parse(referrer)
      host = uri.host&.downcase # Use safe navigation operator to handle nil cases
      return 'Unknown' if host.nil?

      host = host.start_with?('www.') ? host[4..-1] : host

      case host
      when 'google.com', 'google.co.uk', 'google.fr', 'google.de', 'google.es'
        'Google'
      when 'facebook.com', 'fb.com'
        'Facebook'
      when 't.co'
        'Twitter'
      when 'instagram.com'
        'Instagram'
      when 'linkedin.com'
        'LinkedIn'
      when 'youtube.com', 'youtu.be'
        'YouTube'
      when 'pinterest.com'
        'Pinterest'
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
        host.capitalize
      end
    rescue URI::InvalidURIError
      'Unknown'
    end
  end
end
