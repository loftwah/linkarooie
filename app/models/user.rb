class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links

  def github_avatar_url
    "https://github.com/#{username}.png"
  end

end
