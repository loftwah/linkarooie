require 'rails_helper'
require 'aws-sdk-s3'

RSpec.describe DigitalOceanSpacesService do
  let(:bucket_name) { 'linkarooie' }
  let(:service) { described_class.new(bucket_name) }
  let(:s3_resource) { instance_double(Aws::S3::Resource) }
  let(:s3_bucket) { instance_double(Aws::S3::Bucket) }
  let(:s3_object) { instance_double(Aws::S3::Object) }
  let(:file_content) { 'image_content' }
  let(:content_type) { 'image/jpeg' }
  let(:key) { 'avatars/test_image.jpg' }

  before do
    # Correctly mock the S3 Resource and Bucket
    allow(Aws::S3::Resource).to receive(:new).and_return(s3_resource)
    allow(s3_resource).to receive(:bucket).with(bucket_name).and_return(s3_bucket)
    allow(s3_bucket).to receive(:object).with(key).and_return(s3_object)
  end

  describe '#upload_file' do
    it 'uploads the file to DigitalOcean Spaces and returns the public URL' do
      # Mock successful upload
      allow(s3_object).to receive(:put).and_return(true)
      allow(s3_object).to receive(:public_url).and_return("https://#{bucket_name}.syd1.digitaloceanspaces.com/#{key}")

      result = service.upload_file(key, file_content, content_type)

      # Expect the correct methods to be called
      expect(s3_bucket).to have_received(:object).with(key)
      expect(s3_object).to have_received(:put).with(body: file_content, acl: 'public-read', content_type: content_type)
      # Check the returned URL
      expect(result).to eq("https://#{bucket_name}.syd1.digitaloceanspaces.com/#{key}")
    end

    it 'returns nil if the upload fails' do
      # Mock an upload failure
      allow(s3_object).to receive(:put).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Upload failed'))

      result = service.upload_file(key, file_content, content_type)

      # Expect result to be nil
      expect(result).to be_nil
    end
  end

  describe '#delete_file' do
    it 'deletes the file from DigitalOcean Spaces' do
      # Mock successful deletion
      allow(s3_object).to receive(:delete).and_return(true)

      result = service.delete_file(key)

      # Expect the object to be deleted
      expect(s3_bucket).to have_received(:object).with(key)
      expect(s3_object).to have_received(:delete)
      # Expect the result to be nil since it doesn’t return anything on success
      expect(result).to be_nil
    end

    it 'returns nil and logs an error if deletion fails' do
      # Mock a deletion failure
      allow(s3_object).to receive(:delete).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Delete failed'))

      result = service.delete_file(key)

      # Expect result to be nil
      expect(result).to be_nil
    end
  end
end
