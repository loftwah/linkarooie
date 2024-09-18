class DigitalOceanSpacesService
  def initialize(bucket_name = ENV['SPACES_BUCKET_CONTENT']) # Use SPACES_BUCKET_CONTENT for content
    @bucket = S3_CLIENT.bucket(bucket_name)
  end

  # Upload a file to Spaces from local path
  def upload_file_from_path(key, file_path)
    obj = @bucket.object(key)
    obj.upload_file(file_path, acl: 'public-read')
    obj.public_url
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to upload file to Spaces: #{e.message}"
    nil
  end

  # Upload a file to Spaces from content
  def upload_file(key, file_content, content_type)
    obj = @bucket.object(key)
    obj.put(body: file_content, acl: 'public-read', content_type: content_type)
    obj.public_url
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to upload file to Spaces: #{e.message}"
    nil
  end

  # Delete a file from Spaces
  def delete_file(key)
    obj = @bucket.object(key)
    obj.delete
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to delete file from Spaces: #{e.message}"
    nil
  end

  # Example: Downloading a file (Optional)
  def download_file(key)
    obj = @bucket.object(key)
    obj.get.body.read
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to download file from Spaces: #{e.message}"
    nil
  end
end
