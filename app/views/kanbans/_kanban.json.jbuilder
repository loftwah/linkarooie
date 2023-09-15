json.extract! kanban, :id, :name, :description, :cards, :created_at, :updated_at
json.url kanban_url(kanban, format: :json)
