class AddFullNameAndTagsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :tags, :text
  end
end
