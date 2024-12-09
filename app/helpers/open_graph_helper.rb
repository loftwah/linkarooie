# app/helpers/open_graph_helper.rb
module OpenGraphHelper
  include Rails.application.routes.url_helpers

  def set_open_graph_tags(user)
    default_title = 'Linkarooie - Simplify Your Online Presence'
    default_description = 'Manage all your links in one place with Linkarooie.'
    default_image = image_url('default_og_image.png')
    
    content_for :og_title, user.full_name.presence || default_title
    content_for :og_description, user.description.presence&.truncate(160) || default_description
    content_for :og_image, user.og_image_url.presence || default_image
    content_for :og_url, user_links_url(username: user.username)
    
    # Twitter Card specific tags
    content_for :twitter_card, 'summary_large_image'
    content_for :twitter_site, "@#{user.username.downcase}"
    content_for :twitter_creator, "@#{user.username.downcase}"
  end
end