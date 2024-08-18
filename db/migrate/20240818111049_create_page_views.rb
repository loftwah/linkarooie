class CreatePageViews < ActiveRecord::Migration[7.1]
  def change
    create_table :page_views do |t|
      t.references :user, null: false, foreign_key: true
      t.string :path
      t.string :referrer
      t.string :browser
      t.datetime :visited_at

      t.timestamps
    end
  end
end
