# This configuration file will be evaluated by Puma. For more information, see:
# https://puma.io/puma/Puma/DSL.html

# Thread pool configuration
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

# Worker configuration (production)
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY", Concurrent.physical_processor_count))
  workers worker_count if worker_count > 1
  preload_app!
  worker_timeout 30
else
  # Timeout for development
  worker_timeout 3600
end

# Port and environment
port ENV.fetch("PORT", 3000)
environment ENV.fetch("RAILS_ENV", "development")

# PID file
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Plugins
plugin :tmp_restart
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]
