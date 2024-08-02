class CreateAchievements < ActiveRecord::Migration[7.1]
  def change
    create_table :achievements do |t|
      t.string :title
      t.date :date
      t.text :description
      t.string :icon
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end