class AddPublicAnalyticsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :public_analytics, :boolean, default: false
  end
end