class AddPositionToKanbanColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :kanban_columns, :position, :integer
  end
end
