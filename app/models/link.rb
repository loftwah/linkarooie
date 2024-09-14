class Link < ApplicationRecord
  belongs_to :user
  has_many :link_clicks

  scope :visible, -> { where(visible: true) }
  scope :pinned, -> { where(pinned: true) }
  scope :hidden, -> { where(hidden: true) }

  before_save :ensure_unique_position
  before_save :normalize_url

  private

  def ensure_unique_position
    if position.nil?
      self.position = user.links.maximum(:position).to_i + 1
    elsif user.links.where(position: position).where.not(id: id).exists?
      self.position = user.links.maximum(:position).to_i + 1
    end
  end

  def normalize_url
    # Ensure the URL starts with http:// or https://
    unless url.blank? || url =~ /\Ahttps?:\/\//
      self.url = "http://#{url}"
    end
  end
end
