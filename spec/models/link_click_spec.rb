# spec/models/link_click_spec.rb
require 'rails_helper'

RSpec.describe LinkClick, type: :model do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:user) }
  end
end