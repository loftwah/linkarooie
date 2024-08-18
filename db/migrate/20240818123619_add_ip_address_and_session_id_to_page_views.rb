class AddIpAddressAndSessionIdToPageViews < ActiveRecord::Migration[7.1]
  def change
    add_column :page_views, :ip_address, :string
    add_column :page_views, :session_id, :string
  end
end
