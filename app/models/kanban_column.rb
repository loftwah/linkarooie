class KanbanColumn < ApplicationRecord
  belongs_to :kanban
  has_many :cards
end
