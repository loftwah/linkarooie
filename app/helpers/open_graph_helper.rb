module OpenGraphHelper
  include Rails.application.routes.url_helpers

  def set_open_graph_tags(user)
    content_for :og_title, user.full_name
    content_for :og_description, user.description.truncate(160)
    content_for :og_image, url_for("/uploads/og_images/#{user.username}_og.png")
    content_for :og_image_alt, "#{user.full_name}'s profile image"
    content_for :og_url, user_links_url(user.username)
  end
end
