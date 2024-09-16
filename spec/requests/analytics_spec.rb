# spec/requests/analytics_spec.rb

require 'rails_helper'

RSpec.describe 'Analytics', type: :request do
  describe 'GET /:username/analytics' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, public_analytics: true) }

    before do
      create(:daily_metric, user: other_user, date: Date.today)
    end

    context "when viewing another user's analytics" do
      context 'when analytics are public' do
        it 'allows viewing public analytics' do
          get user_analytics_path(username: other_user.username)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Analytics for')
        end
      end
    end

    context "when accessing own analytics" do
      before do
        sign_in user
        create(:daily_metric, user: user, date: Date.today)
      end

      it 'returns a success response' do
        get user_analytics_path(username: user.username)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Analytics for')
      end
    end
  end
end
