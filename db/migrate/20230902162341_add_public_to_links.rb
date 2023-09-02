class AddPublicToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :public, :boolean, default: false, null: false
  end
end
