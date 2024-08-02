namespace :user do
  desc "Set default username for users without one"
  task set_default_usernames: :environment do
    User.where(username: nil).find_each do |user|
      user.update(username: user.email.split('@').first)
    end
  end
end
