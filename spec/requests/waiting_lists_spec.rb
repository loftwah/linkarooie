# spec/requests/waiting_lists_spec.rb
require 'rails_helper'

RSpec.describe "WaitingLists", type: :request do
  describe "POST /waiting_lists" do
    context "with valid parameters" do
      it "creates a new waiting list entry" do
        expect {
          post waiting_lists_path, params: { waiting_list: { email: "test@example.com" } }
        }.to change(WaitingList, :count).by(1)
        
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Thanks for joining our waiting list!")
      end
    end

    context "with invalid parameters" do
      it "does not create a new waiting list entry" do
        expect {
          post waiting_lists_path, params: { waiting_list: { email: "invalid_email" } }
        }.not_to change(WaitingList, :count)
        
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("There was an error")
      end
    end

    context "with duplicate email" do
      before { WaitingList.create(email: "test@example.com") }

      it "does not create a new waiting list entry" do
        expect {
          post waiting_lists_path, params: { waiting_list: { email: "test@example.com" } }
        }.not_to change(WaitingList, :count)
        
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Email has already been taken")
      end
    end
  end
end