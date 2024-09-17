require 'rails_helper'
require 'aws-sdk-s3'

RSpec.describe DigitalOceanSpacesService do
  let(:bucket_name) { 'linkarooie' }
  let(:service) { described_class.new(bucket_name) }
  let(:s3_bucket) { instance_double(Aws::S3::Bucket) }
  let(:s3_object) { instance_double(Aws::S3::Object) }
  let(:file_content) { 'image_content' }
  let(:content_type) { 'image/jpeg' }
  let(:key) { 'avatars/default_avatar.jpg' }

  before do
    # Mock S3 Client initialization and bucket
    allow(S3_CLIENT).to receive(:bucket).with(bucket_name).and_return(s3_bucket)
    allow(s3_bucket).to receive(:object).with(key).and_return(s3_object)
  end

  describe '#upload_file' do
    it 'uploads the file to DigitalOcean Spaces and returns the public URL' do
      # Mock successful upload
      allow(s3_object).to receive(:put).and_return(true)
      allow(s3_object).to receive(:public_url).and_return("https://#{bucket_name}.syd1.digitaloceanspaces.com/#{key}")

      result = service.upload_file(key, file_content, content_type)

      # Verify that the correct methods are called
      expect(s3_bucket).to have_received(:object).with(key)
      expect(s3_object).to have_received(:put).with(body: file_content, acl: 'public-read', content_type: content_type)
      # Ensure the public URL is returned
      expect(result).to eq("https://#{bucket_name}.syd1.digitaloceanspaces.com/#{key}")
    end

    it 'returns nil if the upload fails' do
      # Mock an upload failure
      allow(s3_object).to receive(:put).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Upload failed'))

      result = service.upload_file(key, file_content, content_type)

      # Verify that nil is returned on failure
      expect(result).to be_nil
    end
  end

  describe '#delete_file' do
    it 'deletes the file from DigitalOcean Spaces' do
      # Mock successful deletion
      allow(s3_object).to receive(:delete).and_return(true)

      result = service.delete_file(key)

      # Verify that the correct delete method is called
      expect(s3_bucket).to have_received(:object).with(key)
      expect(s3_object).to have_received(:delete)
      # Ensure the result is nil since the method doesn't return anything on success
      expect(result).to be_nil
    end

    it 'returns nil and logs an error if deletion fails' do
      # Mock a deletion failure
      allow(s3_object).to receive(:delete).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Delete failed'))

      result = service.delete_file(key)

      # Verify that nil is returned on failure
      expect(result).to be_nil
    end
  end

  describe '#download_file' do
    it 'downloads the file from DigitalOcean Spaces' do
      # Mock successful download
      allow(s3_object).to receive(:get).and_return(double(body: double(read: 'file_content')))

      result = service.download_file(key)

      # Verify that the file content is returned
      expect(result).to eq('file_content')
    end

    it 'returns nil if the download fails' do
      # Mock a download failure
      allow(s3_object).to receive(:get).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Download failed'))

      result = service.download_file(key)

      # Verify that nil is returned on failure
      expect(result).to be_nil
    end
  end
end
