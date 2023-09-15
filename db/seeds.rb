# db/seeds.rb

puts "Cleaning up old data"
Card.destroy_all
KanbanColumn.destroy_all  
Kanban.destroy_all

puts "Creating user"
default_user = User.find_or_create_by(email: 'loftwah@linkarooie.com') do |user|
  user.password = 'Password01'
  user.password_confirmation = 'Password01'
  user.username = 'loftwah' 
  user.first_name = 'Dean'
  user.last_name = 'Lofts'
  user.short_description = 'DevOps Engineer, Proompter and a big fan of Open Source.'
  user.tags = 'AWS,DevOps,GitHub,Open Source,Ruby,Ruby on Rails' 
end

puts "Creating Kanban for default user"
my_kanban = Kanban.create(
  name: "Tech Enthusiast Projects",
  description: "Tasks and projects related to my tech interests.",
  user: default_user
)

puts "Creating columns and cards for the Kanban"

backlog = KanbanColumn.create(
  name: "Backlog",
  kanban: my_kanban  
)

Card.create(
  content: "Setup a new AWS EC2 instance for testing",
  position: 0, 
  kanban_column: backlog  
)

Card.create(
  content: "Contribute to an open-source Ruby gem",
  position: 1,
  kanban_column: backlog
)

Card.create(
  content: "Configure GitHub Actions for CI/CD",
  position: 2, 
  kanban_column: backlog
)


todo = KanbanColumn.create(
  name: "In Progress",
  kanban: my_kanban
)

Card.create(
  content: "Create a new Rails 7 app with Hotwire",
  position: 0,
  kanban_column: todo
)

Card.create(
  content: "Study AWS Lambda for serverless functions", 
  position: 1,
  kanban_column: todo
)


completed = KanbanColumn.create(
  name: "Completed",
  kanban: my_kanban
)

Card.create(
  content: "Completed DevOps certification",
  position: 0,
  kanban_column: completed 
)

Card.create(
  content: "Migrated legacy Ruby app to the latest version",
  position: 1,
  kanban_column: completed
)

Card.create(
  content: "Held a workshop on Open Source contributions",
  position: 2,
  kanban_column: completed
)

puts "Seeding completed"