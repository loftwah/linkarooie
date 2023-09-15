class AddDefaultValueToPositionInCards < ActiveRecord::Migration[7.0]
  def change
    change_column_default :cards, :position, 0
  end
end