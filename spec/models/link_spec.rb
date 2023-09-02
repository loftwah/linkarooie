require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user) { create(:user) } # This will use FactoryBot to create a mock User

  it "is valid with valid attributes" do
    link = Link.new(
      user_id: user.id,
      url: "https://www.google.com",
      display_name: "Google",
      enabled: true,
      pinned: false
    )
    expect(link).to be_valid
  end

  it "is valid without a url" do
    link = Link.new(
      user_id: user.id,
      url: nil,
      display_name: "No URL",
      enabled: true,
      pinned: false
    )
    expect(link).to be_valid
  end

  it "is not valid without a user_id" do
    link = Link.new(
      user_id: nil,
      url: "https://www.google.com",
      display_name: "Google",
      enabled: true,
      pinned: false
    )
    expect(link).not_to be_valid
  end
end
