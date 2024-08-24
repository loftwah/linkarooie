require 'rails_helper'

RSpec.describe AnalyticsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
    create(:daily_metric, user: user, date: Date.today)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { username: user.username }
      expect(response).to be_successful
    end

    it "sets the correct instance variables" do
      get :index, params: { username: user.username }
      
      expect(controller.instance_variable_get(:@user)).to eq(user)
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

    context "when viewing another user's analytics" do
      let(:other_user) { create(:user, public_analytics: true) }

      it "allows viewing public analytics" do
        get :index, params: { username: other_user.username }
        expect(response).to be_successful
      end

      it "redirects when trying to view private analytics" do
        other_user.update(public_analytics: false)
        get :index, params: { username: other_user.username }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end