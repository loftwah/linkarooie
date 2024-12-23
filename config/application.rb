require_relative "boot"
require "rails/all"
require_relative "../app/middleware/page_view_tracker"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Linkarooie
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 8.0.
    config.load_defaults 8.0

    # Add directories in `lib` to the autoload and eager load paths.
    config.autoload_lib(ignore: %w[assets tasks])

    # Middleware for tracking page views.
    config.middleware.use PageViewTracker

    # Preserve sign-ups configuration.
    config.sign_ups_open = false

    # Application-specific configuration:
    # Timezone and locale.
    # config.time_zone = "Central Time (US & Canada)"
    # config.i18n.default_locale = :en

    # Eager load additional paths, if needed.
    # config.eager_load_paths << Rails.root.join("extras")

    # Ensure proper timezone handling.
    config.active_support.to_time_preserves_timezone = :zone

    # Use strict freshness checking for caching.
    config.action_dispatch.strict_freshness = true

    # Opt-in to `strict_loading_by_default`, which raises exceptions for lazy-loaded records.
    config.active_record.strict_loading_by_default = true
  end
end
