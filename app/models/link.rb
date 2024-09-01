class Link < ApplicationRecord
  belongs_to :user

  has_many :link_clicks
  
  scope :visible, -> { where(visible: true) }
  scope :pinned, -> { where(pinned: true) }
  scope :hidden, -> { where(hidden: true) }
end