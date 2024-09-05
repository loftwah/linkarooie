require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { email: "test@example.com", password: "password", password_confirmation: "password",
        username: "testuser", full_name: "Test User", tags: "tag1,tag2", avatar_border: "white", invite_code: "POWEROVERWHELMING" }
    }

    context "when sign-ups are enabled" do
      before do
        allow(Rails.application.config).to receive(:sign_ups_open).and_return(true)
      end

      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "correctly processes tags" do
        post :create, params: { user: valid_attributes }
        user = User.last
        tags = user.tags.is_a?(String) ? JSON.parse(user.tags) : user.tags
        expect(tags).to eq(["tag1", "tag2"])
      end
    end

    context "when sign-ups are disabled" do
      before do
        allow(Rails.application.config).to receive(:sign_ups_open).and_return(false)
      end

      it "does not create a new User without a valid invite code and redirects to root path" do
        invalid_attributes = valid_attributes.merge(invite_code: "INVALIDCODE")
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Sign-ups are currently disabled.")
      end

      it "creates a new User with a valid invite code" do
        expect(controller).to receive(:after_sign_up_path_for).with(instance_of(User)).and_return("/path/to/redirect")

        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        
        expect(response).to redirect_to("/path/to/redirect")
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user, tags: ["old_tag1", "old_tag2"].to_json) }

    before do
      sign_in user
    end

    context "with valid params" do
      let(:new_attributes) {
        { full_name: "New Name", tags: "new_tag1,new_tag2", avatar_border: "black" }
      }

      it "updates the requested user" do
        put :update, params: { user: new_attributes }
        user.reload
        expect(user.full_name).to eq("New Name")
        tags = user.tags.is_a?(String) ? JSON.parse(user.tags) : user.tags
        expect(tags).to eq(["new_tag1", "new_tag2"])
        expect(user.avatar_border).to eq("black")
      end
    end
  end
end
