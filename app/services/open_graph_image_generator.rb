class OpenGraphImageGenerator
  # Constants for sizes and paths
  AVATAR_SIZE = 400
  BORDER_SIZE = 5

  def initialize(user)
    @user = user
    @spaces_service = DigitalOceanSpacesService.new
  end

  def generate
    begin
      # Create a temporary working directory
      temp_dir = Dir.mktmpdir
      output_path = File.join(temp_dir, "#{@user.username}_og.png")
      
      template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
      image = MiniMagick::Image.open(template_path)

      # Download and process avatar
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

      # Total content height calculation
      total_height = (AVATAR_SIZE + 2 * BORDER_SIZE) + spacing +
                     name_pointsize * 1.2 + spacing +
                     username_pointsize * 1.2
      total_height += spacing + tag_pointsize * 1.2 if tag_text.present?

      # Calculate starting y-position to center content vertically
      template_height = image.height
      content_start_y = ((template_height - total_height) / 2).to_i

      # Position elements
      current_y = content_start_y

      # Add avatar to the image, centered horizontally
      image = image.composite(avatar) do |c|
        c.gravity 'North'
        c.geometry "+0+#{current_y}"
      end

      current_y += (AVATAR_SIZE + 2 * BORDER_SIZE) + spacing

      # Add text to the image
      image.combine_options do |c|
        c.gravity 'North'
        c.font '/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf'

        # Add full name
        c.fill '#BEF264'
        c.pointsize name_pointsize.to_s
        c.draw "text 0,#{current_y} '#{escape_text(full_name)}'"

        current_y += name_pointsize * 1.2 + spacing

        # Add username
        c.pointsize username_pointsize.to_s
        c.draw "text 0,#{current_y} '#{escape_text(username)}'"

        current_y += username_pointsize * 1.2 + spacing

        # Add tags if present
        if tag_text.present?
          c.fill 'white'
          c.pointsize tag_pointsize.to_s
          c.draw "text 0,#{current_y} '#{escape_text(tag_text)}'"
        end
      end

      # Save the image to temp directory
      image.write(output_path)

      # Upload to DigitalOcean Spaces
      og_image_key = "og_images/#{@user.username}_og.png"
      spaces_url = @spaces_service.upload_file_from_path(og_image_key, output_path)

      # Update user's og_image_url
      @user.update_column(:og_image_url, spaces_url) if spaces_url

      spaces_url
    rescue StandardError => e
      Rails.logger.error("Failed to generate OG image for user #{@user.id}: #{e.message}")
      nil
    ensure
      FileUtils.remove_entry(temp_dir) if temp_dir && File.exist?(temp_dir)
    end
  end

  private

  def valid_image_url?(url)
    return true if url.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/')
    return false if url.blank?

    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.head(uri.path)
    end
    
    response.is_a?(Net::HTTPSuccess) && response['Content-Type'].to_s.start_with?('image/')
  rescue StandardError => e
    Rails.logger.error("Error validating image URL: #{e.message}")
    false
  end

  def download_image(url)
    if url.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/')
      MiniMagick::Image.open(url)
    else
      response = Net::HTTP.get_response(URI.parse(url))
      
      if response.is_a?(Net::HTTPSuccess) && response['Content-Type'].to_s.start_with?('image/')
        MiniMagick::Image.read(response.body)
      else
        MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to download image: #{e.message}")
    MiniMagick::Image.open(Rails.root.join('public', 'avatars', 'default_avatar.jpg'))
  end

  def escape_text(text)
    text.gsub("\\", "\\\\\\").gsub("'", "\\\\'")
  end
end