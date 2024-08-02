class UpdateTagsInUsers < ActiveRecord::Migration[7.1]
  def up
    # SQLite doesn't support changing column types directly, so we'll use a workaround
    add_column :users, :tags_array, :string, default: '[]'
    
    # Migrate data
    User.find_each do |user|
      user.update_column(:tags_array, user.tags) if user.tags.present?
    end
    
    remove_column :users, :tags
    rename_column :users, :tags_array, :tags
  end

  def down
    rename_column :users, :tags, :tags_array
    add_column :users, :tags, :text, default: '[]'
    
    User.find_each do |user|
      user.update_column(:tags, user.tags_array) if user.tags_array.present?
    end
    
    remove_column :users, :tags_array
  end
end