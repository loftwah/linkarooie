class CreateKanbans < ActiveRecord::Migration[7.0]
  def change
    create_table :kanbans do |t|
      t.string :name
      t.string :description
      t.text :cards

      t.timestamps
    end
  end
end
