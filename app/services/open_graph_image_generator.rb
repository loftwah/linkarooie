class OpenGraphImageGenerator
  def initialize(user)
    @user = user
  end

  def generate
    template_path = Rails.root.join('app', 'assets', 'images', 'og_template.png')
    output_path = Rails.root.join('public', 'uploads', 'og_images', "#{@user.username}_og.png")

    image = MiniMagick::Image.open(template_path)
    avatar = download_image(@user.avatar)

    avatar.resize '200x200'

    image.combine_options do |c|
      c.font "Liberation-Sans"
      # Positioning avatar (example: 50px from left, 100px from top)
      c.draw "image Over 50,100 200,200 '#{avatar.path}'"
      
      # Positioning full name
      c.gravity 'NorthWest'
      c.pointsize '36'
      c.draw "text 300,150 '#{@user.full_name}'"

      # Positioning username
      c.pointsize '24'
      c.draw "text 300,200 '#{@user.username}'"

      # Positioning description
      c.pointsize '18'
      c.draw "text 300,250 '#{@user.description.truncate(60)}'"

      # Optionally add tags
      tag_text = @user.parsed_tags.join(', ')
      c.pointsize '18'
      c.draw "text 300,300 '#{tag_text}'"
    end

    image.write(output_path)
    output_path
  end

  private

  def download_image(url)
    tempfile = Tempfile.new(['avatar', '.jpg'])
    tempfile.binmode
    URI.open(url) do |image|
      tempfile.write(image.read)
    end
    tempfile.rewind
    MiniMagick::Image.open(tempfile.path)
  end
end
