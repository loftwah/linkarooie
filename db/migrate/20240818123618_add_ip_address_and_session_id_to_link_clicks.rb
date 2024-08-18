class AddIpAddressAndSessionIdToLinkClicks < ActiveRecord::Migration[7.1]
  def change
    add_column :link_clicks, :ip_address, :string
    add_column :link_clicks, :session_id, :string
  end
end
