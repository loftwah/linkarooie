class User < ApplicationRecord
  FALLBACK_AVATAR_URL = 'https://pbs.twimg.com/profile_images/1581014308397502464/NPogKMyk_400x400.jpg'
  FALLBACK_BANNER_URL = 'https://pbs.twimg.com/profile_banners/1192091185/1719830949/1500x500' # Replace with your actual default banner URL

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
  after_save :generate_open_graph_image, unless: -> { Rails.env.test? }
  after_save :download_and_store_avatar
  after_save :download_and_store_banner

  serialize :tags, coder: JSON

  def parsed_tags
    if tags.is_a?(String)
      begin
        JSON.parse(tags)
      rescue JSON::ParserError
        []
      end
    else
      tags
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
    avatar_local_path.present? ? "/#{avatar_local_path}" : avatar
  end

  def banner_url
    banner_local_path.present? ? "/#{banner_local_path}" : banner
  end

  private

  def download_and_store_image(type, fallback_url)
    url = send(type)
    if url.blank?
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
  
          # Determine the file extension based on content type
          extension = case content_type
                      when 'image/jpeg' then '.jpg'
                      when 'image/png'  then '.png'
                      when 'image/gif'  then '.gif'
                      else ''  # Blank if unknown
                      end
  
          image_dir = Rails.root.join('public', type.to_s.pluralize)
          FileUtils.mkdir_p(image_dir) unless File.directory?(image_dir)
  
          filename = "#{username}_#{type}#{extension}"
          filepath = File.join(image_dir, filename)
  
          File.open(filepath, 'wb') do |file|
            file.write(response.body)
          end
  
          # Update the local path column
          update_column("#{type}_local_path", "#{type.to_s.pluralize}/#{filename}")
  
          Rails.logger.info "#{type.to_s.capitalize} downloaded for user #{username}"
        else
          raise "HTTP Error: #{response.code} #{response.message}"
        end
      end
    rescue StandardError => e
      Rails.logger.error "Failed to download #{type} for user #{username}: #{e.message}. Using fallback #{type}."
      update_column(type, fallback_url)
    end
  end

  def ensure_username_presence
    if username.blank?
      self.username = email.present? ? email.split('@').first : "user#{SecureRandom.hex(4)}"
    end
  end
end