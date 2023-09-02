class AddPositionToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :position, :integer
  end
end
