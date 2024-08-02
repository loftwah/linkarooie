class ChangeTagsToJsonInUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :tags_json, :text, default: '[]'

    # Migrate data from the old tags column to the new tags_json column
    User.reset_column_information
    User.find_each do |user|
      if user.tags.present?
        user.update_column(:tags_json, user.tags.split(',').map(&:strip).to_json)
      end
    end

    # Remove the old tags column
    remove_column :users, :tags

    # Rename the new column to tags
    rename_column :users, :tags_json, :tags
  end
end
