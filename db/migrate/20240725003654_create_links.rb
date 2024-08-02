class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
