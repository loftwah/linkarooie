module ApplicationHelper
  def auto_link_urls(text)
    text.gsub(%r{(https?://[^\s]+)}) do |url|
      "<a href='#{url}' target='_blank' class='text-lime-300 hover:underline'>#{url}</a>"
    end.html_safe
  end
end
