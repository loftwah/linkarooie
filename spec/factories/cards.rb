FactoryBot.define do
  factory :card do
    content { "MyString" }
    position { 1 }
    kanban_column { nil }
  end
end
