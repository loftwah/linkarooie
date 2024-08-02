class AddIconToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :icon, :string
  end
end
