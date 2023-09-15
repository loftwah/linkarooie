class CreateKanbanColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :kanban_columns do |t|
      t.string :name
      t.references :kanban, null: false, foreign_key: true

      t.timestamps
    end
  end
end
