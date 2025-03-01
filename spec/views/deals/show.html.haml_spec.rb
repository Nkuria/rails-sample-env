require 'rails_helper'

RSpec.describe "deals/show", type: :view do
  before(:each) do
    @deal = assign(:deal, Deal.create!(
      transaction: nil,
      item: nil,
      price: 2,
      quantity: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
