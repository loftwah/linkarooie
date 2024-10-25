class User < ApplicationRecord
  FALLBACK_AVATAR_URL = 'https://linkarooie.syd1.digitaloceanspaces.com/defaults/default_avatar.jpg'
  FALLBACK_BANNER_URL = 'https://linkarooie.syd1.digitaloceanspaces.com/defaults/default_banner.jpg'

  attr_accessor :invite_code
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :daily_metrics, dependent: :destroy
  has_many :page_views, dependent: :destroy
  has_many :link_clicks, dependent: :destroy
  has_many :achievement_views, dependent: :destroy

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/

  validates :username, presence: true, uniqueness: true, format: { with: VALID_USERNAME_REGEX, message: 'can only contain letters, numbers, and underscores' }
  validates :full_name, presence: true
  validates :avatar_border, inclusion: { in: ['white', 'black', 'none', 'rainbow', 'rainbow-overlay'] }
  
  # Remove these two lines as we're replacing them with custom validation
  # validates :avatar, format: { with: /\A(https?:\/\/).*\z/i, message: "must be a valid URL" }, allow_blank: true
  # validates :banner, format: { with: /\A(https?:\/\/).*\z/i, message: "must be a valid URL" }, allow_blank: true
  
  # Add this line to use our new custom validation
  validate :validate_image_urls

  before_validation :ensure_username_presence
  before_create :set_default_images
  after_create :generate_open_graph_image_async, unless: -> { Rails.env.test? }
  before_save :process_avatar, if: :will_save_change_to_avatar?
  before_save :process_banner, if: :will_save_change_to_banner?

  serialize :tags, coder: JSON

  def parsed_tags
    if tags.is_a?(String)
      begin
        JSON.parse(tags)
      rescue JSON::ParserError
        []
      end
    else
      tags || []
    end
  end  

  def generate_open_graph_image
    OpenGraphImageGenerator.new(self).generate
  end

  def avatar_url
    avatar.presence || FALLBACK_AVATAR_URL
  end

  def banner_url
    banner.presence || FALLBACK_BANNER_URL
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  private

  def validate_image_urls
    validate_image_url(:avatar, "Avatar")
    validate_image_url(:banner, "Banner")
  end

  def validate_image_url(attribute, attribute_name)
    url = self[attribute]
    return if url.blank?

    # Allow DigitalOcean Spaces URLs without further validation
    return if url.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/')

    unless url.match?(/\A(https?:\/\/).*\z/i)
      errors.add(attribute, "#{attribute_name} URL must start with http:// or https://")
      return
    end

    # Optionally validate the URL, but don't prevent saving if it fails
    unless valid_image_url?(url)
      logger.warn "Warning: #{attribute_name} URL may not be a valid image: #{url}"
    end
  end

  def valid_image_url?(url)
    begin
      response = fetch_head(url)
      return response.is_a?(Net::HTTPSuccess) && response['Content-Type'].to_s.start_with?('image/')
    rescue SocketError, URI::InvalidURIError, Net::OpenTimeout, OpenSSL::SSL::SSLError => e
      logger.error "Error validating image URL: #{url}. Error: #{e.message}"
      false
    end
  end

  def fetch_head(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 5, read_timeout: 5) do |http|
      http.request_head(uri.path)
    end
  end

  def generate_open_graph_image_async
    GenerateOpenGraphImageJob.perform_later(self.id)
  end

  def ensure_username_presence
    if username.blank?
      self.username = email.present? ? email.split('@').first : "user#{SecureRandom.hex(4)}"
    end
  end

  def set_default_images
    self.avatar ||= FALLBACK_AVATAR_URL
    self.banner ||= FALLBACK_BANNER_URL
  end

  def process_avatar
    process_image(:avatar)
  end

  def process_banner
    process_image(:banner)
  end

  def process_image(type)
    url = self[type]
    puts "Processing #{type} for User ID: #{id}, URL: #{url}"  # Debugging output for type and URL
    return if url.blank?
  
    if url.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/')
      puts "URL already points to Spaces, skipping processing."  # Debug output
      return
    end
  
    begin
      response = fetch_image(url)
      puts "Image fetch response: #{response}"  # Debugging output for fetch response
  
      case response
      when Net::HTTPSuccess
        content_type = response['Content-Type']
        puts "Content type: #{content_type}"  # Debugging output for content type
  
        if content_type.start_with?('image/')
          file_path = save_image_locally(type, response.body, content_type)
          puts "Image saved locally at: #{file_path}"  # Debugging output for saved file path
  
          upload_image_to_spaces(type, file_path)
          File.delete(file_path)
        else
          handle_non_image_content(type)
        end
      when Net::HTTPNotFound
        handle_404_error(type)
      else
        handle_other_error(type, response)
      end
    rescue SocketError, URI::InvalidURIError => e
      puts "Error processing image: #{e.message}"  # Debugging output for errors
      handle_invalid_url(type, e)
    end
  end  

  def save_image_locally(type, content, content_type)
    extension = extract_extension(content_type)
    filename = "#{id}_#{type}#{extension}"
    file_path = Rails.root.join('tmp', filename)
    File.open(file_path, 'wb') { |file| file.write(content) }
    file_path
  end

  def upload_image_to_spaces(type, file_path)
    key = "#{type.to_s.pluralize}/#{id}_#{type}.jpg"
    service = DigitalOceanSpacesService.new
    spaces_url = service.upload_file_from_path(key, file_path)
    self[type] = spaces_url if spaces_url
  end

  def fetch_image(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(Net::HTTP::Get.new(uri))
    end
  end

  def extract_extension(content_type)
    case content_type
    when 'image/jpeg' then '.jpg'
    when 'image/png'  then '.png'
    when 'image/gif'  then '.gif'
    else '.jpg'
    end
  end

  def handle_non_image_content(type)
    Rails.logger.warn "Invalid content type for #{type} upload: #{self[type]}"
    self[type] = type == :avatar ? FALLBACK_AVATAR_URL : FALLBACK_BANNER_URL
  end

  def handle_404_error(type)
    Rails.logger.warn "404 error for #{type} upload: #{self[type]}"
    self[type] = type == :avatar ? FALLBACK_AVATAR_URL : FALLBACK_BANNER_URL
  end

  def handle_other_error(type, response)
    Rails.logger.error "Error downloading #{type}: #{response.code} #{response.message}"
    self[type] = type == :avatar ? FALLBACK_AVATAR_URL : FALLBACK_BANNER_URL
  end

  def handle_invalid_url(type, error)
    Rails.logger.error "Invalid URL for #{type}: #{error.message}"
    self[type] = type == :avatar ? FALLBACK_AVATAR_URL : FALLBACK_BANNER_URL
  end
end