class Link < ApplicationRecord
  belongs_to :user
  
  scope :visible, -> { where(visible: true) }
  scope :pinned, -> { where(pinned: true) }
end