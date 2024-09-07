class AddCommunityOptInToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :community_opt_in, :boolean, default: false, null: false
  end
end
