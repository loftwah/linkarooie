class AddAvatarBorderToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar_border, :string, default: 'white'
  end
end
