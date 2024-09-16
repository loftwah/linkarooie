class OpenGraphImageGenerator
  # Constants for sizes and paths
  AVATAR_SIZE = 400
  BORDER_SIZE = 5
  FONT = 'Courier'  # Use a standard block print font

  def initialize(user)
    @user = user
  end

  def generate
    template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
    output_dir = Rails.root.join('public', 'uploads', 'og_images')
    FileUtils.mkdir_p(output_dir) unless File.directory?(output_dir)
    output_path = output_dir.join("#{@user.username}_og.png")

    image = MiniMagick::Image.open(template_path)

    # Determine whether to use fallback avatar or download the provided one
    if @user.avatar.blank? || !valid_image_url?(@user.avatar_url)
      avatar = MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
    else
      avatar = download_image(@user.avatar_url)
    end

    # Resize avatar and add border
    avatar.resize "#{AVATAR_SIZE}x#{AVATAR_SIZE}"
    avatar.combine_options do |c|
      c.bordercolor 'white'
      c.border BORDER_SIZE
    end

    # Prepare text elements
    tag_text = @user.parsed_tags.present? ? @user.parsed_tags.join(' | ') : ""
    full_name = @user.full_name
    username = "@#{@user.username}"

    # Define point sizes
    name_pointsize = 40
    username_pointsize = 28
    tag_pointsize = 20

    # Spacing between elements
    spacing = 10

    # Estimate text heights (approximated as 1.2 times point size)
    name_text_height = name_pointsize * 1.2
    username_text_height = username_pointsize * 1.2
    tag_text_height = tag_pointsize * 1.2 if tag_text.present?

    # Total content height calculation
    total_height = (AVATAR_SIZE + 2 * BORDER_SIZE) + spacing +
                   name_text_height + spacing +
                   username_text_height

    total_height += spacing + tag_text_height if tag_text.present?

    # Calculate starting y-position to center content vertically
    template_height = image.height
    content_start_y = ((template_height - total_height) / 2).to_i

    # Position elements
    current_y = content_start_y

    # Add avatar to the image, centered horizontally
    image = image.composite(avatar) do |c|
      c.gravity 'North'  # Align from the top
      c.geometry "+0+#{current_y}"
    end

    current_y += (AVATAR_SIZE + 2 * BORDER_SIZE) + spacing

    # Add text to the image
    image.combine_options do |c|
      c.gravity 'North'  # Align from the top
      c.font FONT        # Set the font to 'Courier'

      # Add full name
      c.fill '#BEF264'
      c.pointsize name_pointsize.to_s
      c.draw "text 0,#{current_y} '#{escape_text(full_name)}'"

      current_y += name_text_height + spacing

      # Add username
      c.pointsize username_pointsize.to_s
      c.draw "text 0,#{current_y} '#{escape_text(username)}'"

      current_y += username_text_height + spacing

      # Add tags if present
      if tag_text.present?
        c.fill 'white'
        c.pointsize tag_pointsize.to_s
        c.draw "text 0,#{current_y} '#{escape_text(tag_text)}'"
      end
    end

    # Save the generated image
    image.write(output_path)
    output_path
  end

  private

  def valid_image_url?(url)
    return false if url.blank?

    begin
      uri = URI.parse(url)
      return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      return false if uri.host.nil?

      # Check if the response is an image
      response = Net::HTTP.get_response(uri)
      response.is_a?(Net::HTTPSuccess) && response['Content-Type'].start_with?('image/')
    rescue URI::InvalidURIError, SocketError, Errno::ECONNREFUSED => e
      Rails.logger.error("Invalid or unreachable URL: #{url}. Error: #{e.message}.")
      false
    end
  end

  def download_image(url)
    uri = URI.parse(url)
    begin
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        content_type = response['Content-Type']

        # Only proceed if the content-type is an image
        if content_type.start_with?('image/')
          MiniMagick::Image.read(response.body)
        else
          Rails.logger.error("URL does not point to an image: #{url}. Content-Type: #{content_type}. Using fallback.")
          MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
        end
      else
        Rails.logger.error("Failed to download image from URL: #{url}. HTTP Error: #{response.code} #{response.message}. Using fallback.")
        MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
      end
    rescue StandardError => e
      Rails.logger.error("Failed to download image from URL: #{url}. Error: #{e.message}. Using fallback.")
      MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
    end
  end

  def escape_text(text)
    text.gsub("'", "\\\\'")
  end
end
