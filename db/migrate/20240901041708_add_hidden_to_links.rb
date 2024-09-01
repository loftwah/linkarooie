class AddHiddenToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :hidden, :boolean, default: false
  end
end
