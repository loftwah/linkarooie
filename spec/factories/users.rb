FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:username) { |n| "user#{n}" }
    full_name { "Test User" }
    tags { ["tag1", "tag2"].to_json }
    avatar_border { ['white', 'black', 'none'].sample }
  end
end