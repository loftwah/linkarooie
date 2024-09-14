class Achievement < ApplicationRecord
  belongs_to :user
  has_many :achievement_views

  validates :title, presence: true
  validates :date, presence: true
  validates :description, presence: true

  before_save :normalize_url

  private

  def normalize_url
    # Ensure the URL starts with http:// or https://
    unless url.blank? || url =~ /\Ahttps?:\/\//
      self.url = "http://#{url}"
    end
  end
end
