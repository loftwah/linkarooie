class AddFieldsToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :description, :string unless column_exists?(:links, :description)
    add_column :links, :position, :integer unless column_exists?(:links, :position)
  end
end
