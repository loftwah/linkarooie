# db/seeds.rb

default_user = User.find_or_create_by(email: 'loftwah@linkarooie.com') do |user|
    user.password = 'Password01'
    user.password_confirmation = 'Password01'
    # add any other user attributes here
  end
  