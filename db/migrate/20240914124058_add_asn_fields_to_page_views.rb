class AddAsnFieldsToPageViews < ActiveRecord::Migration[7.1]
  def change
    add_column :page_views, :asn, :string
    add_column :page_views, :asn_org, :string
  end
end
