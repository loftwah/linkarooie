# spec/models/daily_metric_spec.rb
require 'rails_helper'

RSpec.describe DailyMetric, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end
end