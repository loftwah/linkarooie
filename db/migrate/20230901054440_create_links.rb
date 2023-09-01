class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url
      t.string :display_name
      t.string :icon
      t.boolean :enabled
      t.boolean :pinned
      t.string :group

      t.timestamps
    end
  end
end
