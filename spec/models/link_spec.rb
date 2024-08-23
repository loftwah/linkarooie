# spec/models/link_spec.rb
require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:link_clicks) }
  end

  describe 'scopes' do
    let!(:visible_link) { create(:link, visible: true) }
    let!(:invisible_link) { create(:link, visible: false) }
    let!(:pinned_link) { create(:link, pinned: true) }
    let!(:unpinned_link) { create(:link, pinned: false) }

    it 'returns only visible links' do
      expect(Link.visible).to include(visible_link)
      expect(Link.visible).not_to include(invisible_link)
    end

    it 'returns only pinned links' do
      expect(Link.pinned).to include(pinned_link)
      expect(Link.pinned).not_to include(unpinned_link)
    end
  end
end