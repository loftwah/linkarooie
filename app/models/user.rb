class User < ApplicationRecord
  FALLBACK_AVATAR_URL = '/avatars/default_avatar.jpg'
  FALLBACK_BANNER_URL = '/banners/default_banner.jpg'

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
  after_save :download_and_store_avatar, if: -> { saved_change_to_avatar? && avatar.present? }
  after_save :download_and_store_banner, if: -> { saved_change_to_banner? && banner.present? }

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

  def download_and_store_avatar
    download_and_store_image(:avatar, FALLBACK_AVATAR_URL)
  end

  def download_and_store_banner
    download_and_store_image(:banner, FALLBACK_BANNER_URL)
  end

  def avatar_url
    avatar_local_path.present? ? "/#{avatar_local_path}" : (avatar.presence || FALLBACK_AVATAR_URL)
  end

  def banner_url
    banner_local_path.present? ? "/#{banner_local_path}" : (banner.presence || FALLBACK_BANNER_URL)
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

  def download_and_store_image(type, fallback_url)
    url = send(type)
  
    if url.blank? || !valid_url?(url)
      Rails.logger.info "#{type.capitalize} URL invalid or blank. Using local fallback."
      update_column(type, fallback_url)
      return
    end
  
    begin
      uri = URI.parse(url)
      
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
  
        if response.is_a?(Net::HTTPSuccess)
          content_type = response['Content-Type']
  
          unless content_type.start_with?('image/')
            raise "Invalid content type: #{content_type}"
          end
  
          extension = case content_type
                      when 'image/jpeg' then '.jpg'
                      when 'image/png'  then '.png'
                      when 'image/gif'  then '.gif'
                      else ''
                      end
  
          image_dir = Rails.root.join('public', type.to_s.pluralize)
          FileUtils.mkdir_p(image_dir) unless File.directory?(image_dir)
  
          filename = "#{username}_#{type}#{extension}"
          filepath = File.join(image_dir, filename)
  
          File.open(filepath, 'wb') { |file| file.write(response.body) }
  
          update_column("#{type}_local_path", "#{type.to_s.pluralize}/#{filename}")
  
          Rails.logger.info "#{type.to_s.capitalize} successfully downloaded for user #{username}"
  
        else
          Rails.logger.warn "Failed to download #{type} for user #{username}: HTTP Error: #{response.code} #{response.message}. Using local fallback."
          update_column(type, fallback_url)
        end
      end
    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.error "SSL error while downloading #{type} for user #{username}: #{e.message}. Using local fallback."
      update_column(type, fallback_url)
    rescue StandardError => e
      Rails.logger.error "Failed to download #{type} for user #{username}: #{e.message}. Using local fallback."
      update_column(type, fallback_url)
    end
  end
end