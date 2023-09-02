class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links
  has_one_attached :background_image

  def github_avatar_url
    "https://github.com/#{username}.png"
  end

end
