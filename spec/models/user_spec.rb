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

  describe '#process_image' do
    let(:user) { create(:user, username: 'testuser') }

    before do
      # Clean up test files
      Dir.glob(Rails.root.join('tmp', '*')).each do |file|
        File.delete(file) unless File.directory?(file)
      end
    end

    context 'when image download fails' do
      it 'keeps the default avatar URL' do
        not_found_response = instance_double(Net::HTTPNotFound)
        allow(not_found_response).to receive(:body).and_return('')
        allow(not_found_response).to receive(:code).and_return('404')
        allow(not_found_response).to receive(:message).and_return('Not Found')
        allow(not_found_response).to receive(:[]).with('Content-Type').and_return('text/html')
        allow(Net::HTTP).to receive(:get_response).and_return(not_found_response)

        expect {
          user.send(:process_image, :avatar)
        }.not_to change { user.avatar }

        expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
      end
    end

    context 'when content type is not an image' do
      it 'keeps the default avatar URL' do
        success_response = instance_double(Net::HTTPSuccess)
        allow(success_response).to receive(:body).and_return('not an image')
        allow(success_response).to receive(:code).and_return('200')
        allow(success_response).to receive(:message).and_return('OK')
        allow(success_response).to receive(:[]).with('Content-Type').and_return('text/plain')
        allow(Net::HTTP).to receive(:get_response).and_return(success_response)

        expect {
          user.send(:process_image, :avatar)
        }.not_to change { user.avatar }

        expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
      end
    end

    context 'when image is already on DigitalOcean Spaces' do
      it 'does not change the avatar URL' do
        user.avatar = "https://linkarooie.syd1.digitaloceanspaces.com/avatars/existing_avatar.jpg"

        expect {
          user.send(:process_image, :avatar)
        }.not_to change { user.avatar }
      end
    end
  end
end