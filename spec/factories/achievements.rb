# spec/factories/achievements.rb
FactoryBot.define do
  factory :achievement do
    title { "My Achievement" }
    date { Date.today }
    description { "This is a test achievement" }
    icon { "fa-trophy" }
    url { nil }
    association :user
  end
end