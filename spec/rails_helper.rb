# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'aws-sdk'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Initialize the test suite and setup AWS configuration
RSpec.configure do |config|
  config.before(:suite) do
    Aws.config.update({
      region: ENV['AWS_REGION'] || 'ap-southeast-2', # Fallback to 'ap-southeast-2' if not set
    })
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
