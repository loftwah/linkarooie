class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  has_many :links
  has_one :kanban
  has_one_attached :background_image

  attr_accessor :remove_background_image, :clear_background_color

  before_save :check_remove_background_image
  before_save :clear_background_color_field, if: ->{ clear_background_color == '1' }

  def check_remove_background_image
    self.background_image.purge if remove_background_image == '1'
  end

  def clear_background_color_field
    self.background_color = nil
  end

  def github_avatar_url
    "https://github.com/#{username}.png"
  end

end
