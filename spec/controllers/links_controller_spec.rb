require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:link) { create(:link, user: user) }

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
    it "redirects to the link url" do
      get :show, params: { id: link.to_param }
      expect(response).to redirect_to(link.url)
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
      it "creates a new Link" do
        expect {
          post :create, params: { link: attributes_for(:link) }
        }.to change(Link, :count).by(1)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { title: "New Title" } }

      it "updates the requested link" do
        put :update, params: { id: link.to_param, link: new_attributes }
        link.reload
        expect(link.title).to eq("New Title")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested link" do
      link # ensure link is created before the expect block
      expect {
        delete :destroy, params: { id: link.to_param }
      }.to change(Link, :count).by(-1)
    end
  end

  describe "GET #user_links" do
    it "returns a success response" do
      get :user_links, params: { username: user.username }
      expect(response).to be_successful
    end

    it "assigns the correct instance variables" do
      get :user_links, params: { username: user.username }
      expect(controller.instance_variable_get(:@user)).to eq(user)
      expect(controller.instance_variable_get(:@links)).to be_an(ActiveRecord::Relation)
      expect(controller.instance_variable_get(:@pinned_links)).to be_an(ActiveRecord::Relation)
      expect(controller.instance_variable_get(:@achievements)).to be_an(ActiveRecord::Relation)
    end
  end
end
