class AddLinksEnabledToLinks < ActiveRecord::Migration[7.0]
  def change
    unless column_exists? :links, :links_enabled
      add_column :links, :links_enabled, :boolean, default: true
    end
  end  
end
