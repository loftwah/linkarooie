require 'rails_helper'

RSpec.describe "Analytics", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/analytics/index"
      expect(response).to have_http_status(:success)
    end
  end

end
