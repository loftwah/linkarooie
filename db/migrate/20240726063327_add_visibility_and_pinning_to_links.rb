# db/migrate/[timestamp]_add_visibility_and_pinning_to_links.rb
class AddVisibilityAndPinningToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :visible, :boolean, default: true
    add_column :links, :pinned, :boolean, default: false
  end
end