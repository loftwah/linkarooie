class AddUniqueVisitorsToDailyMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :daily_metrics, :unique_visitors, :integer
  end
end
