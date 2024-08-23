# spec/factories/links.rb
FactoryBot.define do
  factory :link do
    title { "MyString" }
    url { "http://example.com" }
    visible { true }
    pinned { false }
    association :user
  end
end