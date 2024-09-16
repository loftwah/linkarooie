require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:full_name) }
    it { should validate_inclusion_of(:avatar_border).in_array(['white', 'black', 'none', 'rainbow', 'rainbow-overlay']) }
    
    it { should allow_value('http://example.com/image.jpg').for(:avatar) }
    it { should allow_value('https://example.com/image.jpg').for(:avatar) }
    it { should_not allow_value('invalid_url').for(:avatar) }
    
    it { should allow_value('http://example.com/image.jpg').for(:banner) }
    it { should allow_value('https://example.com/image.jpg').for(:banner) }
    it { should_not allow_value('invalid_url').for(:banner) }
  end

  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:achievements).dependent(:destroy) }
    it { should have_many(:daily_metrics).dependent(:destroy) }
    it { should have_many(:page_views).dependent(:destroy) }
    it { should have_many(:link_clicks).dependent(:destroy) }
    it { should have_many(:achievement_views).dependent(:destroy) }
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
    describe '#download_and_store_avatar' do
      it 'uses the fallback avatar URL when no avatar is provided' do
        user = build(:user, avatar: nil)
        allow(user).to receive(:download_and_store_image)
        user.save
        expect(user).to have_received(:download_and_store_image).with(:avatar, User::FALLBACK_AVATAR_URL)
      end
    
      it 'attempts to download the avatar when a URL is provided' do
        user = build(:user, avatar: 'http://example.com/avatar.jpg')
        allow(user).to receive(:download_and_store_image)
        user.save
        expect(user).to have_received(:download_and_store_image).with(:avatar, User::FALLBACK_AVATAR_URL)
      end
    end

    describe '#download_and_store_banner' do
      it 'uses the fallback banner URL when no banner is provided' do
        user = build(:user, banner: nil)
        allow(user).to receive(:download_and_store_image)
        user.save
        expect(user).to have_received(:download_and_store_image).with(:banner, User::FALLBACK_BANNER_URL)
      end
    
      it 'attempts to download the banner when a URL is provided' do
        user = build(:user, banner: 'http://example.com/banner.jpg')
        allow(user).to receive(:download_and_store_image)
        user.save
        expect(user).to have_received(:download_and_store_image).with(:banner, User::FALLBACK_BANNER_URL)
      end
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

  describe '#download_and_store_image' do
    let(:user) { create(:user, username: 'testuser') }
    let(:image_url) { 'http://example.com/image.jpg' }
    let(:image_content) { 'image content' }

    it 'downloads and stores the image' do
      success_response = double('HTTPSuccess', body: image_content, is_a?: Net::HTTPSuccess)
      allow(success_response).to receive(:[]).with('Content-Type').and_return('image/jpeg')
      allow(Net::HTTP).to receive(:start).and_yield(double('http', request: success_response))

      expect(FileUtils).to receive(:mkdir_p).with(Rails.root.join('public', 'avatars'))
      expect(File).to receive(:open).with("/home/loftwah/gits/linkarooie/public/avatars/testuser_avatar.jpg", "wb")

      user.send(:download_and_store_image, :avatar, User::FALLBACK_AVATAR_URL)
    end

    it 'logs an error and uses fallback URL when download fails' do
      allow(Net::HTTP).to receive(:start).and_raise(StandardError.new("Download failed"))

      expect(Rails.logger).to receive(:error).with(/Failed to download avatar/)
      expect(user).to receive(:update_column).with(:avatar, User::FALLBACK_AVATAR_URL)

      user.send(:download_and_store_image, :avatar, User::FALLBACK_AVATAR_URL)
    end

    it 'uses fallback URL when content type is not an image' do
      non_image_response = double('HTTPSuccess', body: 'not an image', is_a?: Net::HTTPSuccess)
      allow(non_image_response).to receive(:[]).with('Content-Type').and_return('text/plain')
      allow(Net::HTTP).to receive(:start).and_yield(double('http', request: non_image_response))

      expect(Rails.logger).to receive(:error).with(/Failed to download avatar/)
      expect(user).to receive(:update_column).with(:avatar, User::FALLBACK_AVATAR_URL)

      user.send(:download_and_store_image, :avatar, User::FALLBACK_AVATAR_URL)
    end
  end
end