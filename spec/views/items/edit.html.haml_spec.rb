require 'rails_helper'

RSpec.describe 'items/edit', type: :view do
  before(:each) do
    @company = create(:company)
    @item = assign(:item, Item.create!(
                            name: 'MyString',
                            vat: '9.99',
                            company: @company
                          ))
  end

  it 'renders the edit item form with correct Bootstrap classes' do
    render

    assert_select 'form[action=?][method=?]', item_path(@item), 'post' do
      assert_select 'input[name=?][class=?]', 'item[name]', 'form-control form-control-sm'
      assert_select 'input[name=?][class=?]', 'item[vat]', 'form-control form-control-sm'
      assert_select 'select[name=?][class=?]', 'item[company_id]', 'form-select form-select-sm'
      assert_select 'input[type=?][class=?]', 'submit', 'btn btn-primary btn-sm px-4'
    end
  end

  it 'renders validation error messages if present' do
    @item.errors.add(:name, "can't be blank")
    @item.errors.add(:vat, 'must be a number')
    render

    assert_select '.alert.alert-danger' do
      assert_select 'h6', text: '2 errors prevented this item from being saved:'
      assert_select 'ul' do
        assert_select 'li', text: "Name can't be blank"
        assert_select 'li', text: 'Vat must be a number'
      end
    end
  end

  it 'renders show and back buttons' do
    render

    assert_select 'a[href=?][class=?]', item_path(@item), 'btn btn-outline-primary btn-sm', text: 'Show'
    assert_select 'a[href=?][class=?]', items_path, 'btn btn-outline-secondary btn-sm', text: 'Back'
  end
end
