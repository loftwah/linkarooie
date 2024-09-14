class OpenGraphImageGenerator
  # Constants for sizes and paths
  FALLBACK_AVATAR_URL = 'https://pbs.twimg.com/profile_images/1581014308397502464/NPogKMyk_400x400.jpg'

  def initialize(user)
    @user = user
  end

  def generate
    template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
    output_path = Rails.root.join('public', 'uploads', 'og_images', "#{@user.username}_og.png")
    image = MiniMagick::Image.open(template_path)
    
    avatar = @user.avatar.present? ? download_image(@user.avatar) : download_image(FALLBACK_AVATAR_URL)

    # Resize avatar and add a white square border
    avatar.resize "#{AVATAR_SIZE}x#{AVATAR_SIZE}"
    avatar.combine_options do |c|
      c.bordercolor 'white'
      c.border BORDER_SIZE
    end

    # Generate the final image with all elements
    image.combine_options do |c|
      c.font "Liberation-Sans"
      
      # Centered avatar
      c.gravity 'Center'
      c.draw "image Over 0,-100 #{AVATAR_SIZE + 2 * BORDER_SIZE},#{AVATAR_SIZE + 2 * BORDER_SIZE} '#{avatar.path}'"

      # Centered Full name
      c.fill '#BEF264'
      c.pointsize '40'
      c.draw "text 0,50 '#{@user.full_name}'"

      # Centered Username with "@" symbol
      c.pointsize '28'
      c.draw "text 0,100 '@#{@user.username}'"

      # Centered Tags, in white
      tag_text = @user.parsed_tags.join(' | ')
      c.fill 'white'
      c.pointsize '20'
      c.draw "text 0,150 '#{tag_text}'"
    end

    image.write(output_path)
    output_path
  end

  private

  def download_image(url)
    uri = URI.parse(url)
    tempfile = Tempfile.new(['avatar', '.jpg'])
    tempfile.binmode
    begin
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        tempfile.write(response.body)
        tempfile.rewind
        MiniMagick::Image.open(tempfile.path)
      else
        Rails.logger.error("Failed to download image from URL: #{url}. HTTP Error: #{response.code} #{response.message}.")
        MiniMagick::Image.open(FALLBACK_AVATAR_URL)
      end
    rescue SocketError, Errno::ENOENT => e
      Rails.logger.error("Failed to download image from URL: #{url}. Error: #{e.message}. Using fallback URL.")
      MiniMagick::Image.open(FALLBACK_AVATAR_URL)
    ensure
      tempfile.close
      tempfile.unlink  # Unlink after we've processed the image
    end
  end  
end
