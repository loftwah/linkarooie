require 'rails_helper'

RSpec.describe 'Analytics', type: :request do
  describe 'GET /index' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns http success' do
      get analytics_path
      puts response.body # Add this line to print the response body in case of an error
      expect(response).to have_http_status(:success)
    end
  end
end
