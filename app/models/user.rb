class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy
  has_many :achievements, dependent: :destroy

  has_many :page_views
  has_many :link_clicks
  has_many :achievement_views

  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true

  before_validation :set_default_username, on: :create
  after_save :generate_open_graph_image
  after_save :download_and_store_avatar

  serialize :tags, JSON

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
    return if avatar.blank? || !avatar.start_with?('http')
  
    require 'open-uri'
    require 'fileutils'
  
    begin
      avatar_dir = Rails.root.join('public', 'avatars')
      FileUtils.mkdir_p(avatar_dir) unless File.directory?(avatar_dir)
  
      file = URI.open(avatar)
  
      filename = "#{username}_avatar#{File.extname(avatar)}"
      filepath = File.join(avatar_dir, filename)
  
      File.open(filepath, 'wb') do |local_file|
        local_file.write(file.read)
      end
  
      Rails.logger.info "Avatar downloaded for user #{username}"
    rescue StandardError => e
      Rails.logger.error "Failed to download avatar for user #{username}: #{e.message}"
    end
  end

  private

  def set_default_username
    self.username ||= email.split('@').first
  end
end