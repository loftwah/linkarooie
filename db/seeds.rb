# db/seeds.rb

puts "Creating user"
default_user = User.find_or_create_by(email: 'loftwah@linkarooie.com') do |user|
  user.password = 'Password01'
  user.password_confirmation = 'Password01'
  user.username = 'loftwah'
  user.first_name = 'Dean'
  user.last_name = 'Lofts'
  user.short_description = 'DevOps Engineer, Promoter and a big fan of Open Source.'
  user.tags = 'AWS,DevOps,GitHub,Open Source,Ruby,Ruby on Rails'
end
