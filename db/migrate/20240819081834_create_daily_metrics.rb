class CreateDailyMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_metrics do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :page_views
      t.integer :link_clicks
      t.integer :achievement_views

      t.timestamps
    end
  end
end
