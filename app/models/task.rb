# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :user
  acts_as_list scope: :user

  validates :description, presence: true
end
