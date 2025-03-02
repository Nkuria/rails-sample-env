require 'rails_helper'

RSpec.describe 'items/show', type: :view do
  before(:each) do
    @company = create(:company, name: 'TechCorp')
    @item = assign(:item, Item.create!(name: 'Sample Item', vat: 12, company: @company))
  end

  it 'displays item details correctly' do
    render

    assert_select 'h5.card-title.text-center.mb-3', text: 'Item Details'

    assert_select 'p.mb-2', text: /Name:\s+Sample Item/
    assert_select 'p.mb-2', text: /Vat:\s+12/
    assert_select 'p.mb-2', text: /Company:\s+TechCorp/
  end

  it 'renders the Edit and Back buttons' do
    render

    assert_select 'a[href=?][class=?]', edit_item_path(@item), 'btn btn-primary btn-sm', text: 'Edit'
    assert_select 'a[href=?][class=?]', items_path, 'btn btn-outline-secondary btn-sm', text: 'Back'
  end
end
