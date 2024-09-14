require 'maxmind/geoip2'

class PageViewTracker
  def initialize(app)
    @app = app
    # Load MaxMind readers for ASN, City, and Country databases
    @asn_reader = MaxMind::GeoIP2::Reader.new('db/GeoLite2-ASN.mmdb')     # ASN database
    @city_reader = MaxMind::GeoIP2::Reader.new('db/GeoLite2-City.mmdb')   # City database
    @country_reader = MaxMind::GeoIP2::Reader.new('db/GeoLite2-Country.mmdb') # Country database
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    status, headers, response = @app.call(env)

    if html_response?(headers) && !request.path.start_with?('/assets', '/rails/active_storage')
      track_page_view(request)
    end

    [status, headers, response]
  end

  private

  def html_response?(headers)
    headers['Content-Type']&.include?('text/html')
  end

  def track_page_view(request)
    user = User.find_by(username: request.path.split('/').last)
    if user
      # Extract the original IP from the Cloudflare headers if available
      real_ip = request.headers['CF-Connecting-IP'] || request.headers['X-Forwarded-For']&.split(',')&.first || request.ip

      # ASN lookup
      asn_record = @asn_reader.asn(real_ip) rescue nil

      # City lookup
      city_record = @city_reader.city(real_ip) rescue nil

      # Country lookup (fallback if city is not found)
      country_record = @country_reader.country(real_ip) rescue nil

      PageView.create(
        user: user,
        path: request.path,
        referrer: request.referrer,
        browser: request.user_agent,
        visited_at: Time.current,
        ip_address: real_ip,
        session_id: request.session[:session_id],
        country: city_record&.country&.iso_code || country_record&.country&.iso_code,
        city: city_record&.city&.name,
        state: city_record&.subdivisions&.first&.iso_code,
        latitude: city_record&.location&.latitude,
        longitude: city_record&.location&.longitude,
        country_code: city_record&.country&.iso_code || country_record&.country&.iso_code,
        asn: asn_record&.autonomous_system_number,
        asn_org: asn_record&.autonomous_system_organization
      )
    end
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info "Duplicate page view detected and ignored"
  rescue => e
    Rails.logger.error "Error tracking page view: #{e.message}"
  end
end
