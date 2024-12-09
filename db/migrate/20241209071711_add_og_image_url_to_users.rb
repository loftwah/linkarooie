class AddOgImageUrlToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :og_image_url, :string
  end
end