# spec/models/page_view_spec.rb
require 'rails_helper'

RSpec.describe PageView, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end
end