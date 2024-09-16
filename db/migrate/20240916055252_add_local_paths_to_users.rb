class AddLocalPathsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar_local_path, :string
    add_column :users, :banner_local_path, :string
  end
end