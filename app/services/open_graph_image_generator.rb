class OpenGraphImageGenerator
  IMAGE_WIDTH = 1200
  IMAGE_HEIGHT = 630
  AVATAR_SIZE = 200
  BORDER_SIZE = 10

  def initialize(user)
    @user = user
  end

  def generate
    template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
    output_path = Rails.root.join('public', 'uploads', 'og_images', "#{@user.username}_og.png")
    image = MiniMagick::Image.open(template_path)
    avatar = download_image(@user.avatar)

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
    tempfile = Tempfile.new(['avatar', '.jpg'])
    tempfile.binmode
    begin
      URI.open(url) do |image|
        tempfile.write(image.read)
      end
    rescue OpenURI::HTTPError, Errno::ENOENT, SocketError => e
      Rails.logger.error("Failed to download image from URL: #{url}. Error: #{e.message}. Using default image.")
      # Use a default image if the download fails
      default_image_path = Rails.root.join('app', 'assets', 'images', 'greg.jpg')
      tempfile.write(File.read(default_image_path))
    end
    tempfile.rewind
    MiniMagick::Image.open(tempfile.path)
  end
end
