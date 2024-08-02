class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar, :string
    add_column :users, :banner, :string
    add_column :users, :description, :text
  end
end
