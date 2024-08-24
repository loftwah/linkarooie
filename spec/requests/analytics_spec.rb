require 'rails_helper'

RSpec.describe 'Analytics', type: :request do
  describe 'GET /:username/analytics' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns http success' do
      get user_analytics_path(username: user.username)
      expect(response).to have_http_status(:success)
    end

    it 'renders the correct content' do
      get user_analytics_path(username: user.username)
      expect(response.body).to include('Analytics')  # Adjust this to match your actual content
    end

    context "when viewing another user's analytics" do
      let(:other_user) { create(:user, public_analytics: true) }

      it "allows viewing public analytics" do
        get user_analytics_path(username: other_user.username)
        expect(response).to have_http_status(:success)
      end

      it "redirects when trying to view private analytics" do
        other_user.update(public_analytics: false)
        get user_analytics_path(username: other_user.username)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end