class AddIpAddressAndSessionIdToAchievementViews < ActiveRecord::Migration[7.1]
  def change
    add_column :achievement_views, :ip_address, :string
    add_column :achievement_views, :session_id, :string
  end
end
