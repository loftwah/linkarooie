# app/models/task.rb
class Task < ApplicationRecord
    belongs_to :user
  
    validates :description, presence: true
    validates :status, presence: true, inclusion: { in: ['To-do', 'In-progress', 'Completed'] }
    validates :priority, numericality: { only_integer: true }
    validates :category, length: { maximum: 50 }
  end
  