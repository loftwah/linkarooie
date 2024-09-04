# spec/models/waiting_list_spec.rb
require 'rails_helper'

RSpec.describe WaitingList, type: :model do
  it "has a valid factory" do
    expect(build(:waiting_list)).to be_valid
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it "validates email format" do
      valid_emails = ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org"]
      invalid_emails = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com"]
      
      valid_emails.each do |email|
        expect(build(:waiting_list, email: email)).to be_valid
      end
      
      invalid_emails.each do |email|
        expect(build(:waiting_list, email: email)).to be_invalid
      end
    end
  end
end