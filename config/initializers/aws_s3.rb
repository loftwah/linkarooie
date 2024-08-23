require 'aws-sdk-s3'

Aws.config.update({
  region: ENV['SPACES_REGION'] || 'syd1',
  credentials: Aws::Credentials.new(
    ENV['SPACES_ACCESS_KEY_ID'],
    ENV['SPACES_SECRET_ACCESS_KEY']
  ),
  endpoint: "https://#{ENV['SPACES_REGION'] || 'syd1'}.digitaloceanspaces.com"
})

S3_CLIENT = Aws::S3::Resource.new
