namespace :users do
  desc "Download and store avatars for all users"
  task download_avatars: :environment do
    User.find_each do |user|
      user.download_and_store_avatar
      puts "Processed avatar for user #{user.id}"
    end
  end
end