FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:username) { |n| "user#{n}" }
    full_name { "Test User" }
    community_opt_in { [true, false].sample }
    invite_code { "POWEROVERWHELMING" }
    avatar_border { ['white', 'black', 'none'].sample }
  end
end