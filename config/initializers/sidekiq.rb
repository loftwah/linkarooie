unless ENV['PRECOMPILE_ASSETS']
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
    config.logger.level = Logger::INFO
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  end

  if Rails.env.production?
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq_scheduler.yml', __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
end