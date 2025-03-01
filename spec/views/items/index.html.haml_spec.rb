require 'rails_helper'

RSpec.describe 'items/index', type: :view do
  before(:each) do
    assign(:items, [
             Item.create!(
               name: 'Name',
               vat: '9.99',
               company: nil
             ),
             Item.create!(
               name: 'Name',
               vat: '9.99',
               company: nil
             )
           ])
  end

  it 'renders a list of items' do
    render
    assert_select 'tr>td', text: 'Name', count: 2
    assert_select 'tr>td', text: '9.99', count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
