require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }  # Removed .allow_blank
    it { should validate_presence_of(:full_name) }
  end

  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:achievements).dependent(:destroy) }
    it { should have_many(:daily_metrics) }
    it { should have_many(:page_views) }
    it { should have_many(:link_clicks) }
    it { should have_many(:achievement_views) }
  end

  describe 'username generation' do
    it 'sets default username from email if username is blank' do
      user = User.new(email: 'test@example.com', password: 'password', full_name: 'Test User')
      user.valid?
      expect(user.username).to eq('test')
    end

    it 'sets a random username when email and username are blank' do
      user = User.new(password: 'password', full_name: 'Test User')
      user.valid?
      expect(user.username).to match(/^user[a-f0-9]{8}$/)
    end

    it 'does not change username if it is already set' do
      user = User.new(email: 'test@example.com', username: 'customuser', password: 'password', full_name: 'Test User')
      user.valid?
      expect(user.username).to eq('customuser')
    end
  end

  describe 'callbacks' do
    it 'uses the fallback avatar URL when no avatar is provided' do
      user = build(:user, avatar: nil)
      user.save
      expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
    end
  
    it 'handles invalid avatar URLs and falls back to default' do
      user = build(:user, avatar: 'http://invalid-url.com/avatar.jpg')
      user.save
      expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
    end
  end  

  describe '#parsed_tags' do
    it 'returns parsed JSON when tags is a valid JSON string' do
      user = User.new(tags: '["ruby", "rails"]')
      expect(user.parsed_tags).to eq(['ruby', 'rails'])
    end

    it 'returns an empty array when tags is an invalid JSON string' do
      user = User.new(tags: 'invalid json')
      expect(user.parsed_tags).to eq([])
    end

    it 'returns tags as-is when it is already an array' do
      user = User.new(tags: ['ruby', 'rails'])
      expect(user.parsed_tags).to eq(['ruby', 'rails'])
    end
  end
end
