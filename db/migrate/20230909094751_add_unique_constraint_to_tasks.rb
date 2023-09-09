class AddUniqueConstraintToTasks < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, [:user_id, :status, :position], unique: true
  end
end
