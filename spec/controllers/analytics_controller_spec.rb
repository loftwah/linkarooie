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
      expect(assigns(:total_page_views)).to be_a(Integer)
      expect(assigns(:total_link_clicks)).to be_a(Integer)
      expect(assigns(:total_achievement_views)).to be_a(Integer)
      expect(assigns(:unique_visitors)).to be_a(Integer)
      expect(assigns(:latest_daily_metric)).to be_a(DailyMetric)
      expect(assigns(:link_analytics)).to be_an(Array)
      expect(assigns(:achievement_analytics)).to be_an(Array)
      expect(assigns(:daily_views)).to be_a(Hash)
      expect(assigns(:browser_data)).to be_a(Hash)
    end
  end
end