require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests. Ensures consistency and avoids reload overhead in production.
  config.enable_reloading = false

  # Eager load code on boot. Recommended for production to optimise performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Suppresses SQLite3 production warnings.
  config.active_record.sqlite3_production_warning = false

  # Ensure a master key is available for decrypting credentials.
  # Uncomment and use if needed:
  # config.require_master_key = true

  # Disable serving static files via Rails. A reverse proxy like NGINX/Apache should handle this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Use a CSS compressor if necessary.
  # config.assets.css_compressor = :sass

  # Disable assets pipeline fallback to avoid slow runtime compilation.
  config.assets.compile = false

  # Precompile and serve assets from an asset server, if used.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header for sending files via NGINX/Apache.
  # Uncomment if using a specific server:
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files locally. Update this for cloud services in production.
  config.active_storage.service = :local

  # Logging: Improved formatting and tagging.
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend log lines with request ID tags.
  config.log_tags = [:request_id]

  # Default log level. "debug" for detailed info, "info" for general operations.
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # Enable locale fallbacks for missing translations.
  config.i18n.fallbacks = [I18n.default_locale]

  # Prevent dumping the schema after migrations in production.
  config.active_record.dump_schema_after_migration = false

  # Caching backend setup (Redis is recommended for production).
  # Uncomment if using Redis:
  # config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

  # Action Mailer setup for email delivery via SMTP.
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp-relay.gmail.com",
    port: 587,
    domain: "linkarooie.com",  # Replace with your domain
    enable_starttls_auto: true,
    openssl_verify_mode: 'none'
  }
  config.action_mailer.default_url_options = { host: "linkarooie.com" }

  # Report deprecations via Rails.logger.
  config.active_support.report_deprecations = false

  # Host-based access control to prevent DNS rebinding attacks.
  # Uncomment and configure allowed hosts as needed:
  # config.hosts << "linkarooie.com"

  # Strict transport security (use with reverse proxy SSL).
  # Uncomment if enforcing HTTPS:
  # config.force_ssl = true
end
