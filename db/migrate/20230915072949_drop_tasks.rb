class DropTasks < ActiveRecord::Migration[6.1]  # Adjust the version accordingly
  def up
    drop_table :tasks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end