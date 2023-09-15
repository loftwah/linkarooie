require 'rails_helper'

RSpec.describe "kanbans/index", type: :view do
  before(:each) do
    assign(:kanbans, [
      Kanban.create!(
        name: "Name",
        description: "Description",
        cards: "MyText"
      ),
      Kanban.create!(
        name: "Name",
        description: "Description",
        cards: "MyText"
      )
    ])
  end

  it "renders a list of kanbans" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
