class AddBannerEnabledToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :banner_enabled, :boolean, default: true
  end
end
