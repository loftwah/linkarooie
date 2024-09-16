class OpenGraphImageGenerator
  # Constants for sizes and paths
  AVATAR_SIZE = 400
  BORDER_SIZE = 5

  def initialize(user)
    @user = user
  end

  def generate
    template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
    output_path = Rails.root.join('public', 'uploads', 'og_images', "#{@user.username}_og.png")
    image = MiniMagick::Image.open(template_path)
  
    # Skip download if the avatar is the fallback image
    avatar = if @user.avatar_url == User::FALLBACK_AVATAR_URL
               MiniMagick::Image.open(Rails.root.join('public', User::FALLBACK_AVATAR_URL))
             else
               download_image(@user.avatar_url)
             end
  
    # Resize avatar and continue as before
    avatar.resize "#{AVATAR_SIZE}x#{AVATAR_SIZE}"
    avatar.combine_options do |c|
      c.bordercolor 'white'
      c.border BORDER_SIZE
    end
  
    image.combine_options do |c|
      c.font "Liberation-Sans"
  
      c.gravity 'Center'
      c.draw "image Over 0,-100 #{AVATAR_SIZE + 2 * BORDER_SIZE},#{AVATAR_SIZE + 2 * BORDER_SIZE} '#{avatar.path}'"
  
      c.fill '#BEF264'
      c.pointsize '40'
      c.draw "text 0,50 '#{@user.full_name}'"
  
      c.pointsize '28'
      c.draw "text 0,100 '@#{@user.username}'"
  
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
        MiniMagick::Image.open(@user.avatar_url)
      end
    rescue SocketError, Errno::ENOENT => e
      Rails.logger.error("Failed to download image from URL: #{url}. Error: #{e.message}. Using fallback URL.")
      MiniMagick::Image.open(@user.avatar_url)
    ensure
      tempfile.close
      tempfile.unlink  # Unlink after we've processed the image
    end
  end  
end