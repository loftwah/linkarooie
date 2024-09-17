# lib/tasks/populate_image_local_paths.rake
namespace :users do
  desc "Populate avatar and banner local paths for existing users"
  task populate_image_local_paths: :environment do
    User.find_each do |user|
      Rails.logger.info "Processing user: #{user.username}"
      
      avatar_valid = user.valid_url?(user.avatar)
      banner_valid = user.valid_url?(user.banner)

      Rails.logger.info "User: #{user.username}, Avatar URL: #{user.avatar}, Valid: #{avatar_valid}"
      Rails.logger.info "User: #{user.username}, Banner URL: #{user.banner}, Valid: #{banner_valid}"

      user.send(:download_and_store_image, :avatar, User::FALLBACK_AVATAR_URL)
      user.send(:download_and_store_image, :banner, User::FALLBACK_BANNER_URL)

      print "."
    end
    puts "\nDone!"
  end
end
