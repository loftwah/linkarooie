require 'rails_helper'

RSpec.describe OpenGraphImageGenerator do
  let(:user) { create(:user, username: 'testuser', full_name: 'Test User', tags: ['ruby', 'rails'].to_json) }
  let(:spaces_service) { instance_double(DigitalOceanSpacesService) }
  let(:spaces_url) { 'https://linkarooie.syd1.digitaloceanspaces.com/og_images/testuser_og.png' }

  before do
    allow(DigitalOceanSpacesService).to receive(:new).and_return(spaces_service)
    allow(spaces_service).to receive(:upload_file_from_path)
      .with("og_images/#{user.username}_og.png", anything)
      .and_return(spaces_url)
  end

  describe '#generate' do
    it 'generates and uploads the image to Spaces' do
      result = described_class.new(user).generate
      expect(result).to eq(spaces_url)
      expect(user.reload.og_image_url).to eq(spaces_url)
    end

    context 'with different avatar sources' do
      it 'handles Spaces avatars' do
        user.update(avatar: 'https://linkarooie.syd1.digitaloceanspaces.com/avatars/test.png')
        expect(spaces_service).to receive(:upload_file_from_path)
          .with("og_images/#{user.username}_og.png", anything)
          .and_return(spaces_url)
        
        result = described_class.new(user).generate
        expect(result).to eq(spaces_url)
      end

      it 'uses default avatar for invalid URLs' do
        user.update(avatar: 'invalid-url')
        expect(spaces_service).to receive(:upload_file_from_path)
          .with("og_images/#{user.username}_og.png", anything)
          .and_return(spaces_url)
        
        result = described_class.new(user).generate
        expect(result).to eq(spaces_url)
      end
    end

    context 'when errors occur' do
      it 'handles upload failures' do
        allow(spaces_service).to receive(:upload_file_from_path).and_return(nil)
        result = described_class.new(user).generate
        expect(result).to be_nil
        expect(user.reload.og_image_url).to be_nil
      end

      it 'logs errors and returns nil' do
        allow(spaces_service).to receive(:upload_file_from_path)
          .and_raise(StandardError.new("Upload failed"))

        expect(Rails.logger).to receive(:error)
          .with("Failed to generate OG image for user #{user.id}: Upload failed")

        result = described_class.new(user).generate
        expect(result).to be_nil
      end
    end
  end
end