# spec/models/achievement_spec.rb
require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:achievement_views) }
  end
end