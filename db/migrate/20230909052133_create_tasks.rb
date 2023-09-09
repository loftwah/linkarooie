class CreateTasks < ActiveRecord::Migration[6.1]  # adjust the version number if needed
  def change
    create_table :tasks do |t|
      t.string :description
      t.string :status
      t.integer :priority
      t.string :category
      t.integer :user_id

      t.timestamps
    end
  end
end
