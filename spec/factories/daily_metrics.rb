# spec/factories/daily_metrics.rb
FactoryBot.define do
  factory :daily_metric do
    user
    date { Date.today }
    page_views { 10 }
    link_clicks { 5 }
    achievement_views { 3 }
    unique_visitors { 2 }
  end
end