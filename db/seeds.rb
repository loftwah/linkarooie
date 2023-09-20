# db/seeds.rb

ActiveRecord::Base.transaction do
  # Create default user
  puts "Creating or finding user"
  default_user = User.find_or_create_by!(email: 'loftwah@linkarooie.com') do |user|
    user.password = 'Password01'
    user.password_confirmation = 'Password01'
    user.username = 'loftwah'
    user.first_name = 'Dean'
    user.last_name = 'Lofts'
    user.short_description = 'DevOps Engineer, Proompter and a big fan of Open Source.'
    user.tags = 'AWS,DevOps,GitHub,Open Source,Ruby,Ruby on Rails'
  end

  # Create Kanban Board
  puts "Creating or finding demo Kanban Board"
  demo_kanban = Kanban.find_or_create_by!(name: 'Linkarooie Project', user_id: default_user.id) do |kanban|
    kanban.description = 'This is a demo board for Linkarooie application.'
  end

  # Create Kanban Columns and Cards
  puts "Creating or updating Kanban Columns and Cards"
  ['Backlog', 'In Progress', 'Completed'].each do |col_name|
    column = demo_kanban.kanban_columns.find_or_create_by!(name: col_name)

    tasks = case col_name
            when 'Backlog'
              ['Set up the initial Rails project', 'Create Models and Migrations', 'Install Devise for User Authentication']
            when 'In Progress'
              ['Develop CRUD operations for Links', 'Implement AWS S3 Storage']
            when 'Completed'
              ['Initial Project Setup', 'Setup GitHub Actions for CI/CD']
            end

    tasks.each_with_index do |task, _index|
      column.cards.find_or_create_by!(content: task)
    end
  end

  puts "Seeding complete."
end
