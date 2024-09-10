namespace :links do
  desc "Normalize link positions for all users"
  task normalize_positions: :environment do
    User.find_each do |user|
      user.links.order(:position).each_with_index do |link, index|
        # Update the position to be sequential starting from 1
        link.update_column(:position, index + 1)
      end
      puts "Normalized positions for user #{user.id}."
    end
  end
end
