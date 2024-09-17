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
    # Clean up test files (optional)
    Dir.glob(Rails.root.join('public', 'avatars', '*')).each do |file|
      File.delete(file) unless file.include?('default_avatar.jpg')
    end
  end

  it 'uploads the image to DigitalOcean Spaces and updates avatar' do
    # Step 1: Mock HTTP response for downloading image
    success_response = instance_double('Net::HTTPSuccess', body: 'image content', is_a?: true)
    allow(success_response).to receive(:[]).with('Content-Type').and_return('image/jpeg')
    allow(Net::HTTP).to receive(:start).and_return(success_response)

    # Step 2: Mock DigitalOceanSpacesService
    service_instance = instance_double(DigitalOceanSpacesService)
    allow(DigitalOceanSpacesService).to receive(:new).and_return(service_instance)
    allow(service_instance).to receive(:upload_file_from_path)
      .and_return("https://linkarooie.syd1.digitaloceanspaces.com/avatars/testuser_avatar.jpg")

    # Step 3: Run the method
    user.send(:process_image, :avatar)
    user.reload

    # Ensure that the avatar field is updated correctly
    expect(user.avatar).to eq("https://linkarooie.syd1.digitaloceanspaces.com/avatars/testuser_avatar.jpg")

    # Step 4: Ensure that upload_file_from_path was called
    expect(service_instance).to have_received(:upload_file_from_path).with("avatars/#{user.id}_avatar.jpg", anything)
  end

  it 'uses fallback avatar URL when download fails' do
    allow(Net::HTTP).to receive(:start).and_raise(StandardError.new('Download failed'))
    user.send(:process_image, :avatar)
    user.reload
    expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
  end

  it 'uses fallback avatar URL when content type is not an image' do
    non_image_response = instance_double('Net::HTTPSuccess', body: 'not an image', is_a?: true)
    allow(non_image_response).to receive(:[]).with('Content-Type').and_return('text/plain')
    allow(Net::HTTP).to receive(:start).and_return(non_image_response)

    user.send(:process_image, :avatar)
    user.reload
    expect(user.avatar).to eq(User::FALLBACK_AVATAR_URL)
  end
end
end
