# app/models/user.rb
class User < ApplicationRecord
  attr_accessor :invite_code
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy
  has_many :achievements, dependent: :destroy

  has_many :daily_metrics
  has_many :page_views
  has_many :link_clicks
  has_many :achievement_views

  validates :username, uniqueness: true, allow_blank: true
  validates :full_name, presence: true
  validate :ensure_username_presence
  validates :avatar_border, inclusion: { in: ['white', 'black', 'none', 'rainbow', 'rainbow-overlay'] }
  validates :avatar, format: { with: /\A(https?:\/\/).*\z/i, message: "must be a valid URL" }, allow_blank: true

  after_save :generate_open_graph_image, unless: -> { Rails.env.test? }
  after_save :download_and_store_avatar

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
    return if avatar.blank?

    begin
      avatar_dir = Rails.root.join('public', 'avatars')
      FileUtils.mkdir_p(avatar_dir) unless File.directory?(avatar_dir)

      uri = URI.parse(avatar)
      filename = "#{username}_avatar#{File.extname(avatar)}"
      filepath = File.join(avatar_dir, filename)

      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        File.open(filepath, 'wb') do |local_file|
          local_file.write(response.body)
        end
        Rails.logger.info "Avatar downloaded for user #{username}"
      else
        Rails.logger.error "Failed to download avatar for user #{username}. HTTP Error: #{response.code} #{response.message}. Using default avatar."
        self.avatar = 'greg.jpg'  # Set to default avatar
        save(validate: false)  # Save without triggering validations
      end
    rescue StandardError => e
      Rails.logger.error "Failed to download avatar for user #{username}: #{e.message}"
      self.avatar = 'greg.jpg'  # Set to default avatar
      save(validate: false)  # Save without triggering validations
    end
  end

  private

  def ensure_username_presence
    if username.blank?
      self.username = email.present? ? email.split('@').first : "user#{SecureRandom.hex(4)}"
    end
  end
end