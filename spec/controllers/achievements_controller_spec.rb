# spec/controllers/achievements_controller_spec.rb
require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  let(:user) { create(:user) }
  let(:achievement) { create(:achievement, user: user) }

  before do
    sign_in user  # Sign in the user before each test
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    context "when achievement doesn't have a URL" do
      it "returns a success response" do
        get :show, params: { id: achievement.to_param }
        expect(response).to be_successful
      end
    end

    context "when achievement has a URL" do
      let(:achievement_with_url) { create(:achievement, user: user, url: 'http://example.com') }

      it "redirects to the achievement URL" do
        get :show, params: { id: achievement_with_url.to_param }
        expect(response).to redirect_to(achievement_with_url.url)
      end
    end

    it "creates an AchievementView" do
      expect {
        get :show, params: { id: achievement.to_param }
      }.to change(AchievementView, :count).by(1)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Achievement" do
        expect {
          post :create, params: { achievement: attributes_for(:achievement) }
        }.to change(Achievement, :count).by(1)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { title: "New Title" } }

      it "updates the requested achievement" do
        put :update, params: { id: achievement.to_param, achievement: new_attributes }
        achievement.reload
        expect(achievement.title).to eq("New Title")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested achievement" do
      achievement # ensure achievement is created before the expect block
      expect {
        delete :destroy, params: { id: achievement.to_param }
      }.to change(Achievement, :count).by(-1)
    end
  end
end
