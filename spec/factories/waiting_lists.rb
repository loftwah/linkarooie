# spec/factories/waiting_lists.rb
FactoryBot.define do
  factory :waiting_list do
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end