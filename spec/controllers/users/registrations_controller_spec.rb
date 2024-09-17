require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "when sign-ups are closed" do
      before do
        allow(Rails.application.config).to receive(:sign_ups_open).and_return(false)
      end

      it "allows registration with valid invite code" do
        expect {
          post :create, params: { user: attributes_for(:user, invite_code: "POWEROVERWHELMING") }
        }.to change(User, :count).by(1)
      end

      it "denies registration without valid invite code" do
        expect {
          post :create, params: { user: attributes_for(:user, invite_code: "INVALID") }
        }.not_to change(User, :count)
      end
    end

    context "when sign-ups are open" do
      before do
        allow(Rails.application.config).to receive(:sign_ups_open).and_return(true)
      end

      it "allows registration without invite code" do
        expect {
          post :create, params: { user: attributes_for(:user, invite_code: nil) }
        }.to change(User, :count).by(1)
      end
    end

    it "sends a welcome email" do
      expect {
        post :create, params: { user: attributes_for(:user) }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "handles tags correctly" do
      post :create, params: { user: attributes_for(:user, tags: "ruby, rails") }
      expect(User.last.tags).to eq(["ruby", "rails"].to_json)
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "with valid parameters" do
      it "updates non-sensitive information without password" do
        put :update, params: { user: { full_name: "New Name" } }
        expect(user.reload.full_name).to eq("New Name")
      end

      it "updates avatar and provides appropriate message" do
        put :update, params: { user: { avatar: "https://example.com/new_avatar.jpg" } }
        expect(response).to redirect_to(edit_user_registration_path)
        expect(flash[:notice]).to include("Image processing may take a few moments")
      end

      it "updates tags" do
        put :update, params: { user: { tags: "ruby, rails, testing" } }
        expect(user.reload.tags).to eq(["ruby", "rails", "testing"].to_json)
      end
    end

    context "with sensitive parameters" do
      it "requires current password to change email" do
        put :update, params: { user: { email: "new@example.com", current_password: user.password } }
        expect(user.reload.email).to eq("new@example.com")
      end

      it "requires current password to change username" do
        put :update, params: { user: { username: "newusername", current_password: user.password } }
        expect(user.reload.username).to eq("newusername")
      end

      it "fails to update email without current password" do
        put :update, params: { user: { email: "new@example.com" } }
        expect(user.reload.email).not_to eq("new@example.com")
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        put :update, params: { user: { email: "" } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user, tags: ["ruby", "rails"].to_json) }
    before { sign_in user }

    it "assigns tags as a comma-separated string" do
      get :edit
      expect(assigns(:user).tags).to eq("ruby, rails")
    end
  end
end