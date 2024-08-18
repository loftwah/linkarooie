class CreateLinkClicks < ActiveRecord::Migration[7.1]
  def change
    create_table :link_clicks do |t|
      t.references :link, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :clicked_at
      t.string :referrer
      t.string :browser

      t.timestamps
    end
  end
end
