class Kanban < ApplicationRecord
  belongs_to :user
  has_many :kanban_columns, dependent: :destroy

  accepts_nested_attributes_for :kanban_columns, allow_destroy: true
end
