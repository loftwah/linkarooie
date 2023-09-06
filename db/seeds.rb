# db/seeds.rb

default_user = User.find_or_create_by(email: 'loftwah@linkarooie.com') do |user|
    user.password = 'Password01'
    user.password_confirmation = 'Password01'
    user.username = 'loftwah'
    user.first_name = 'Dean'
    user.last_name = 'Lofts'
    user.short_description = 'DevOps Engineer, Proompter and a big fan of Open Source.'
    user.tags = 'AWS,DevOps,GitHub,Open Source,Ruby,Ruby on Rails'
  end
  
  # Add default links only if the user is newly created
  if default_user.new_record?
    Link.create(
      user_id: default_user.id, 
      links_group: 'GitHub', 
      links_url: 'https://github.com', 
      links_display_name: 'GitHub', 
      links_icon: 'fab fa-github', 
      links_enabled: true, 
      links_pinned: false,
      public: false,
      position: 0
    )
    Link.create(
      user_id: default_user.id, 
      links_group: 'GitHub', 
      links_url: 'https://github.com/loftwah', 
      links_display_name: 'GitHub', 
      links_icon: 'fab fa-github', 
      links_enabled: true, 
      links_pinned: false,
      public: true,
      position: 99
    )
  end
  