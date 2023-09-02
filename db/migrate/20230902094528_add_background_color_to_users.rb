class AddBackgroundColorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :background_color, :string
  end
end
