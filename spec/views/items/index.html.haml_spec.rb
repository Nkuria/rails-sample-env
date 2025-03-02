require 'rails_helper'

RSpec.describe 'items/index', type: :view do
  before(:each) do
    company = create(:company)
    assign(:items, [
             Item.create!(name: 'Item 1', vat: 10, company: company),
             Item.create!(name: 'Item 2', vat: 15, company: company)
           ])
  end

  it 'renders the items table with correct headers' do
    render

    assert_select 'h1.text-center.fw-bold.mb-4.text-primary', text: 'Listing Items'

    assert_select 'table.table.table-striped.table-hover.shadow-sm' do
      assert_select 'thead.thead-light' do
        assert_select 'tr' do
          assert_select 'th', text: 'Name'
          assert_select 'th', text: 'Vat'
          assert_select 'th', text: 'Company'
          assert_select 'th.text-center', text: 'Actions'
        end
      end
    end
  end

  it 'renders a list of items with correct data' do
    render

    assert_select 'tbody' do
      assert_select 'tr', count: 2 do |rows|
        rows.each_with_index do |row, index|
          assert_select row, 'td', text: "Item #{index + 1}"
        end
      end
    end
  end

  it 'renders action buttons for each item' do
    render

    Item.all.each do |item|
      assert_select 'a[href=?][class=?]', item_path(item), 'btn btn-outline-primary btn-sm me-1', text: 'Show'
      assert_select 'a[href=?][class=?]', edit_item_path(item), 'btn btn-outline-secondary btn-sm me-1', text: 'Edit'
      assert_select 'a[href=?][class=?]', item_path(item), 'btn btn-outline-danger btn-sm', text: 'Destroy'
    end
  end

  it 'renders the New Item button' do
    render

    assert_select 'a[href=?][class=?]', new_item_path, 'btn btn-primary btn-sm', text: 'New Item'
  end
end
