# spec/controllers/analytics_controller_spec.rb
require 'rails_helper'

RSpec.describe AnalyticsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
    create(:daily_metric, user: user, date: Date.today)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns the correct instance variables" do
      get :index
      expect(controller.instance_variable_get(:@total_page_views)).to be_a(Integer)
      expect(controller.instance_variable_get(:@total_link_clicks)).to be_a(Integer)
      expect(controller.instance_variable_get(:@total_achievement_views)).to be_a(Integer)
      expect(controller.instance_variable_get(:@unique_visitors)).to be_a(Integer)
      expect(controller.instance_variable_get(:@latest_daily_metric)).to be_a(DailyMetric)
      expect(controller.instance_variable_get(:@link_analytics)).to be_an(Array)
      expect(controller.instance_variable_get(:@achievement_analytics)).to be_an(Array)
      expect(controller.instance_variable_get(:@daily_views)).to be_a(Hash)
      expect(controller.instance_variable_get(:@browser_data)).to be_a(Hash)
    end
  end
end
