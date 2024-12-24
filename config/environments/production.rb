require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true

  config.assets.compile = false
  config.active_storage.service = :local

  # Logging
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp-relay.gmail.com",
    port: 587,
    domain: "linkarooie.com",
    enable_starttls_auto: true,
    openssl_verify_mode: "none"
  }
  config.action_mailer.default_url_options = { host: "linkarooie.com" }

  # Active Record
  config.active_record.dump_schema_after_migration = false

  # Deprecations
  config.active_support.report_deprecations = false

  # Uncomment if needed:
  # config.force_ssl = true
  # config.asset_host = "http://assets.example.com"
end
