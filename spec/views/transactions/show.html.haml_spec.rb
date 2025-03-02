# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/show', type: :view do
  before(:each) do
    @user = create(:user, name: 'John Doe')
    @customer = create(:customer, name: 'Acme Corp')
    @item = create(:item, name: 'Sample Item', vat: 16)

    @transaction = create(:transaction, user: @user, customer: @customer)

    # Stub calculated methods
    allow(@transaction).to receive(:total_amount).and_return(5000)
    allow(@transaction).to receive(:total_vat).and_return(800)
    allow(@transaction).to receive(:transaction_amount).and_return(4200)

    @deals = [
      create(:deal, txn: @transaction, item: @item, price: 1000, quantity: 2),
      create(:deal, txn: @transaction, item: @item, price: 500, quantity: 4)
    ]
  end

  it 'displays transaction details' do
    render

    assert_select 'h5.card-title', text: 'Transaction Details'

    assert_select 'p', text: /User:\s*John Doe/
    assert_select 'p', text: /Customer:\s*Acme Corp/
    assert_select 'p', text: /Amount:\s*5000/
  end

  it 'displays the deals table with correct columns' do
    render

    assert_select 'table.table' do
      assert_select 'thead tr' do
        assert_select 'th', text: 'Item'
        assert_select 'th', text: 'Price'
        assert_select 'th', text: 'Quantity'
        assert_select 'th', text: 'Subtotal'
        assert_select 'th', text: 'vat_rate'
        assert_select 'th', text: 'vat_amount'
        assert_select 'th', text: 'total'
      end
      assert_select 'tbody tr', count: 2
    end
  end

  it 'displays transaction totals in the table footer' do
    render

    assert_select 'tfoot tr' do
      assert_select 'th', text: 'Total Before VAT:'
      assert_select 'td', text: '4200'
    end

    assert_select 'tfoot tr' do
      assert_select 'th', text: 'VAT:'
      assert_select 'td', text: '800'
    end

    assert_select 'tfoot tr' do
      assert_select 'th', text: 'Total Amount:'
      assert_select 'td', text: '5000'
    end
  end

  it 'displays edit and back buttons' do
    render

    assert_select 'a[href=?]', edit_transaction_path(@transaction), text: 'Edit'
    assert_select 'a[href=?]', transactions_path, text: 'Back'
  end
end
