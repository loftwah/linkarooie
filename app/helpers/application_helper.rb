module ApplicationHelper
    def background_style(user)
      styles = []
      if user&.background_image&.attached?
        styles << "background-image: url(#{url_for(user.background_image)});"
        styles << "background-size: cover;"
        styles << "background-position: center;"
        styles << "background-repeat: no-repeat;"
        styles << "background-attachment: fixed;"
      end
      styles << "background-color: #{user.background_color};" if user&.background_color.present?
      styles.join(' ')
    end
  end