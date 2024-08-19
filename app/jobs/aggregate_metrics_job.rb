class AggregateMetricsJob < ApplicationJob
  queue_as :default

  def perform
    date = Date.yesterday
    User.find_each do |user|
      DailyMetric.create(
        user: user,
        date: date,
        page_views: user.page_views.where(visited_at: date.all_day).count,
        link_clicks: user.link_clicks.where(clicked_at: date.all_day).count,
        achievement_views: user.achievement_views.where(viewed_at: date.all_day).count,
        unique_visitors: user.page_views.where(visited_at: date.all_day).select(:ip_address).distinct.count
      )
    end
  end
end