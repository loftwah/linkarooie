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
      PageView.create(
        user: user,
        path: request.path,
        referrer: request.referrer,
        browser: request.user_agent,
        visited_at: Time.current,
        ip_address: request.ip,
        session_id: request.session[:session_id]
      )
    end
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info "Duplicate page view detected and ignored"
  end
end