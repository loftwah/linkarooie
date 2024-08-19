require 'rails_helper'

RSpec.describe "Analytics", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "returns http success" do
      get "/analytics"
      expect(response).to have_http_status(:success)
    end
  end
end