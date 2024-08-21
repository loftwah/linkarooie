FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    full_name { "Test User" }
    username { "testuser" }
    tags { "[]" }
  end
end