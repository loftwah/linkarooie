class Achievement < ApplicationRecord
  belongs_to :user

  has_many :achievement_views

  validates :title, presence: true
  validates :date, presence: true
  validates :description, presence: true
end