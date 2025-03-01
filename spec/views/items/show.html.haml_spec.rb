require 'rails_helper'

RSpec.describe 'items/show', type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
                            name: 'Name',
                            vat: '9.99',
                            company: nil
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
  end
end
