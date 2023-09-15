class Kanban < ApplicationRecord
    serialize :cards, JSON
    belongs_to :user
    has_many :kanban_columns
  end
  