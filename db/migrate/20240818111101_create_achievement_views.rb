class CreateAchievementViews < ActiveRecord::Migration[7.1]
  def change
    create_table :achievement_views do |t|
      t.references :achievement, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :viewed_at
      t.string :referrer
      t.string :browser

      t.timestamps
    end
  end
end
