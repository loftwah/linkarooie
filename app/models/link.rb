class Link < ApplicationRecord
  belongs_to :user
  has_many :link_clicks

  scope :visible, -> { where(visible: true) }
  scope :pinned, -> { where(pinned: true) }
  scope :hidden, -> { where(hidden: true) }

  before_save :ensure_unique_position

  private

  def ensure_unique_position
    if position.nil?
      self.position = user.links.maximum(:position).to_i + 1
    elsif user.links.where(position: position).where.not(id: id).exists?
      self.position = user.links.maximum(:position).to_i + 1
    end
  end
end
