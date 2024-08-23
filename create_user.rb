# create_user.rb

require_relative 'config/environment'

def prompt(message)
  print "#{message}: "
  gets.chomp
end

email = prompt("Enter email")
password = prompt("Enter password")
username = prompt("Enter username (or leave blank to use email prefix)")
full_name = prompt("Enter full name")
tags = prompt("Enter tags (comma-separated)")
avatar = prompt("Enter avatar URL")
banner = prompt("Enter banner URL")
description = prompt("Enter description")

username = email.split('@').first if username.strip.empty?
tags = tags.split(',').map(&:strip).to_json unless tags.strip.empty?

user = User.new(
  email: email,
  password: password,
  username: username,
  full_name: full_name,
  tags: tags || '[]',
  avatar: avatar,
  banner: banner,
  description: description
)

if user.save
  puts "User #{user.username} created successfully."
else
  puts "Error creating user: #{user.errors.full_messages.join(', ')}"
end
