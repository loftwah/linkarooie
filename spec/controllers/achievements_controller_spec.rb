require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  render_views  # Add this line to render the actual views

  let(:user) { create(:user) }
  let(:achievement) { create(:achievement, user: user) }
  let(:achievement_with_url) { create(:achievement, user: user, url: 'https://example.com') }

  before do
    sign_in user  # Sign in the user before each test
  end

  describe "GET #index" do
  it "returns a success response" do
    get :index
    expect(response).to be_successful
  end

  it "returns the achievements for the logged-in user" do
    # Ensure the achievement is associated with the signed-in user
    user.achievements << achievement

    get :index
    expect(controller.instance_variable_get(:@achievements)).to eq([achievement])
  end
end

  describe "GET #show" do
    context "when the achievement has a URL" do
      it "redirects to the achievement's URL" do
        get :show, params: { id: achievement_with_url.to_param }
        expect(response).to redirect_to('https://example.com')
      end
    end

    context "when the achievement does not have a URL" do
      it "renders the achievement details" do
        get :show, params: { id: achievement.to_param }
        expect(response).to be_successful
        expect(response.body).to include(achievement.title)
      end

      it "creates an AchievementView" do
        expect {
          get :show, params: { id: achievement.to_param }
        }.to change(AchievementView, :count).by(1)
      end
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
