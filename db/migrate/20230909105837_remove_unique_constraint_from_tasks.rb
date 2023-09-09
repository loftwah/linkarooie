class RemoveUniqueConstraintFromTasks < ActiveRecord::Migration[7.0]
  def change
    remove_index :tasks, name: "index_tasks_on_user_id_and_status_and_position"
  end
end
