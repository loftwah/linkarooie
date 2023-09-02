class Link < ApplicationRecord
  default_scope { order(position: :asc) }
  belongs_to :user
end
