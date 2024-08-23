# spec/controllers/pages_controller_spec.rb
require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "returns a success response" do
      get :home
      expect(response).to be_successful
    end
  end
end