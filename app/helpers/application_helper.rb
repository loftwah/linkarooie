module ApplicationHelper
  def auto_link_urls(text)
    text.gsub(%r{(https?://[^\s]+)}) do |url|
      "<a href='#{url}' target='_blank' class='text-lime-300 hover:underline'>#{url}</a>"
    end.html_safe
  end

  def format_referrer(referrer)
    return 'Direct' if referrer.blank?

    uri = URI.parse(referrer)
    host = uri.host.downcase
    if host.start_with?('www.')
      host = host[4..-1]
    end
    
    case host
    when 'google.com', 'google.co.uk', 'google.fr', 'google.de', 'google.es'
      'Google'
    when 'facebook.com'
      'Facebook'
    when 't.co'
      'Twitter'
    when 'instagram.com'
      'Instagram'
    when 'linkedin.com'
      'LinkedIn'
    else
      host.capitalize
    end
  rescue URI::InvalidURIError
    'Unknown'
  end
end
