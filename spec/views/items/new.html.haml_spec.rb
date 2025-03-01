require 'rails_helper'

RSpec.describe 'items/new', type: :view do
  before(:each) do
    assign(:item, Item.new(
                    name: 'MyString',
                    vat: '9.99',
                    company: nil
                  ))
  end

  it 'renders new item form' do
    render

    assert_select 'form[action=?][method=?]', items_path, 'post' do
      assert_select 'input[name=?]', 'item[name]'

      assert_select 'input[name=?]', 'item[vat]'

      assert_select 'input[name=?]', 'item[company_id]'
    end
  end
end
