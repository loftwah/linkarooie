# db/seeds.rb

# Clear old data
puts "Cleaning up old data"
Card.destroy_all
KanbanColumn.destroy_all
Kanban.destroy_all
User.destroy_all  # Remove this line if you don't want to reset the User

# Create default user
puts "Creating user"
default_user = User.create!(
  email: 'loftwah@linkarooie.com',
  password: 'Password01',
  password_confirmation: 'Password01',
  username: 'loftwah',
  first_name: 'Dean',
  last_name: 'Lofts',
  short_description: 'DevOps Engineer, Proompter and a big fan of Open Source.',
  tags: 'AWS,DevOps,GitHub,Open Source,Ruby,Ruby on Rails'
)

# Create Kanban Board
puts "Creating demo Kanban Board"
demo_kanban = Kanban.create!(
  name: 'Linkarooie Project',
  description: 'This is a demo board for Linkarooie application.',
  user_id: default_user.id
)

# Create Kanban Columns and Cards
puts "Creating Kanban Columns and Cards"
['Backlog', 'In Progress', 'Completed'].each do |col_name|
  column = demo_kanban.kanban_columns.create!(name: col_name)
  
  case col_name
  when 'Backlog'
    tasks = [
      'Set up the initial Rails project',
      'Create Models and Migrations',
      'Install Devise for User Authentication'
    ]
  when 'In Progress'
    tasks = [
      'Develop CRUD operations for Links',
      'Implement AWS S3 Storage'
    ]
  when 'Completed'
    tasks = [
      'Initial Project Setup',
      'Setup GitHub Actions for CI/CD'
    ]
  end

  tasks.each_with_index do |task, index|
    column.cards.create!(content: task)
  end
end

puts "Seeding complete."
