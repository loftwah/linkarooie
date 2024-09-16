# lib/tasks/populate_image_local_paths.rake
namespace :users do
  desc "Populate avatar and banner local paths for existing users"
  task populate_image_local_paths: :environment do
    User.find_each do |user|
      user.send(:download_and_store_image, :avatar, User::FALLBACK_AVATAR_URL)
      user.send(:download_and_store_image, :banner, User::FALLBACK_BANNER_URL)
      print "."
    end
    puts "\nDone!"
  end
end