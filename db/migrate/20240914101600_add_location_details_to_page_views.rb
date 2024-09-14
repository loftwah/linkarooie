class AddLocationDetailsToPageViews < ActiveRecord::Migration[7.1]
  def change
    add_column :page_views, :country, :string
    add_column :page_views, :city, :string
    add_column :page_views, :state, :string
    add_column :page_views, :county, :string
    add_column :page_views, :latitude, :float
    add_column :page_views, :longitude, :float
    add_column :page_views, :country_code, :string
  end
end