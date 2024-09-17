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
  validates :avatar, format: { with: /\A(https?:\/\/).*\z/i, message: "must be a valid URL" }, allow_blank: true
  validates :banner, format: { with: /\A(https?:\/\/).*\z/i, message: "must be a valid URL" }, allow_blank: true

  before_validation :ensure_username_presence
  before_create :set_default_images
  after_create :generate_open_graph_image, unless: -> { Rails.env.test? }
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
    return if url.blank?

    if url.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/')
      # URL is already a Spaces URL, no need to process
      return
    end

    begin
      response = fetch_image(url)
      
      case response
      when Net::HTTPSuccess
        content_type = response['Content-Type']
        
        if content_type.start_with?('image/')
          upload_image_to_spaces(type, response.body, content_type)
        else
          handle_non_image_content(type)
        end
      when Net::HTTPNotFound
        handle_404_error(type)
      else
        handle_other_error(type, response)
      end
    rescue SocketError, URI::InvalidURIError => e
      handle_invalid_url(type, e)
    end
  end

  def fetch_image(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(Net::HTTP::Get.new(uri))
    end
  end

  def upload_image_to_spaces(type, content, content_type)
    extension = extract_extension(content_type)
    filename = "#{id}_#{type}#{extension}"
    key = "#{type.to_s.pluralize}/#{filename}"

    spaces_url = upload_to_spaces(content, key)
    self[type] = spaces_url if spaces_url
  end

  def upload_to_spaces(content, key)
    bucket = S3_CLIENT.bucket(ENV['SPACES_BUCKET_IMAGES'])
    obj = bucket.object(key)
    
    obj.put(body: content, acl: 'public-read')
    
    "https://#{ENV['SPACES_BUCKET_IMAGES']}.syd1.digitaloceanspaces.com/#{key}"
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to upload to Spaces: #{e.message}"
    nil
  end

  def extract_extension(content_type)
    case content_type
    when 'image/jpeg' then '.jpg'
    when 'image/png'  then '.png'
    when 'image/gif'  then '.gif'
    else '.jpg'  # Default to jpg if unknown
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