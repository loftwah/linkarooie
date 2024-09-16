module OpenGraphHelper
  include Rails.application.routes.url_helpers

  def set_open_graph_tags(user)
    # Fallback values for Open Graph
    default_title = 'Linkarooie - Simplify Your Online Presence'
    default_description = 'Manage all your links in one place with Linkarooie. Create a central hub for your social and professional profiles.'
    default_image = image_url('default_og_image.png')
    default_image_alt = 'Linkarooie logo'
    default_url = root_url
    twitter_handle = user.username&.downcase || '@loftwah'

    # Open Graph tags with fallback values
    content_for :og_title, user.full_name || default_title
    content_for :og_description, (user.description || default_description).truncate(160)
    content_for :og_image, user.username.present? ? url_for("/uploads/og_images/#{user.username}_og.png") : default_image
    content_for :og_image_alt, user.full_name.present? ? "#{user.full_name}'s profile image" : default_image_alt
    content_for :og_url, user_links_url(user.username || default_url)

    # Twitter Card tags with fallback values
    content_for :twitter_card, 'summary_large_image'
    content_for :twitter_site, "@#{twitter_handle}"
    content_for :twitter_creator, "@#{twitter_handle}"
  end
end
