class PageViewTracker
  def initialize(app)
    @app = app
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
  
      location = OFFLINE_GEOCODER.search(real_ip)
      
      PageView.create(
        user: user,
        path: request.path,
        referrer: request.referrer,
        browser: request.user_agent,
        visited_at: Time.current,
        ip_address: real_ip,
        session_id: request.session[:session_id],
        country: location[:country],
        city: location[:name],
        state: location[:admin1],
        county: location[:admin2],
        latitude: location[:lat],
        longitude: location[:lon],
        country_code: location[:cc]
      )
    end
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info "Duplicate page view detected and ignored"
  rescue => e
    Rails.logger.error "Error tracking page view: #{e.message}"
  end  
end