# config/initializers/cache_expiration.rb
CACHE_EXPIRATION = ENV.fetch("CACHE_EXPIRATION", 30).to_i.minutes
