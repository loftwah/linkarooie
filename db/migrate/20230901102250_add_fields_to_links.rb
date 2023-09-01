class AddFieldsToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :links_group, :string
    add_column :links, :links_url, :string
    add_column :links, :links_display_name, :string
    add_column :links, :links_icon, :string
    add_column :links, :links_enabled, :boolean
    add_column :links, :links_pinned, :boolean
  end
end
