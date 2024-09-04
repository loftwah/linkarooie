class CreateWaitingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :waiting_lists do |t|
      t.string :email

      t.timestamps
    end
  end
end
