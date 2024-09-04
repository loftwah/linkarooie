# spec/controllers/waiting_lists_controller_spec.rb
require 'rails_helper'

RSpec.describe WaitingListsController, type: :controller do
  describe "POST #create" do
    context "with valid params" do
      it "creates a new WaitingList" do
        expect {
          post :create, params: { waiting_list: attributes_for(:waiting_list) }
        }.to change(WaitingList, :count).by(1)
      end

      it "redirects to the root path with a success notice" do
        post :create, params: { waiting_list: attributes_for(:waiting_list) }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Thanks for joining our waiting list!")
      end
    end

    context "with invalid params" do
      it "does not create a new WaitingList" do
        expect {
          post :create, params: { waiting_list: { email: "invalid_email" } }
        }.to_not change(WaitingList, :count)
      end

      it "redirects to the root path with an error alert" do
        post :create, params: { waiting_list: { email: "invalid_email" } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("There was an error")
      end
    end

    context "with duplicate email" do
      before { create(:waiting_list, email: "test@example.com") }

      it "does not create a new WaitingList" do
        expect {
          post :create, params: { waiting_list: { email: "test@example.com" } }
        }.to_not change(WaitingList, :count)
      end

      it "redirects to the root path with an error alert" do
        post :create, params: { waiting_list: { email: "test@example.com" } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("Email has already been taken")
      end
    end
  end
end