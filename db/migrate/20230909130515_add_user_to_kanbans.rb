class AddUserToKanbans < ActiveRecord::Migration[7.0]
  def change
    add_reference :kanbans, :user, null: false, foreign_key: true
  end
end
