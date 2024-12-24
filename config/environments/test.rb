require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  
  # This is the key change - we need eager loading in test for Devise
  config.eager_load = true
  
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.allow_forgery_protection = false
  config.active_storage.service = :test
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # Mail config
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.active_support.deprecation = :stderr
  config.active_support.report_deprecations = true

  config.action_controller.raise_on_missing_callback_actions = true
end