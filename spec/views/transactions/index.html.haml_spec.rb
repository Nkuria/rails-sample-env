require 'rails_helper'

RSpec.describe 'transactions/index', type: :view do
  before(:each) do
    @user = create(:user, name: 'John Doe')
    @customer = create(:customer, name: 'Acme Corp')
    @transactions = assign(:transactions, [
                             create(:transaction, user: @user, customer: @customer, amount: 1000),
                             create(:transaction, user: @user, customer: @customer, amount: 2000)
                           ])
    assign(:q, Transaction.ransack)
    assign(:pagy, Pagy.new(count: 2, page: 1))
  end

  it 'renders the transactions table with transactions' do
    render

    assert_select 'h5.card-title', text: 'Listing Transactions'

    assert_select 'table.table' do
      assert_select 'thead tr' do
        assert_select 'th', text: 'User'
        assert_select 'th', text: 'Customer'
        assert_select 'th', text: 'Amount'
        assert_select 'th', text: 'Actions'
      end
      assert_select 'tbody tr', count: 2
    end
  end

  it 'renders the filtering form' do
    render

    assert_select 'form[action=?][method=?]', transactions_path, 'get' do
      assert_select 'select[name=?]', 'q[customer_id_eq]'
      assert_select 'input[name=?]', 'q[created_at_gteq]'
      assert_select 'input[name=?]', 'q[created_at_lteq]'
      assert_select 'input[type=submit][value=?]', 'Filter'
      assert_select 'a[href=?]', transactions_path, text: 'Reset'
    end
  end

  it 'renders transaction actions' do
    render

    @transactions.each do |transaction|
      assert_select 'a[href=?]', transaction_path(transaction), text: 'Show'
      assert_select 'a[href=?]', edit_transaction_path(transaction), text: 'Edit'
      assert_select 'a[href=?]', transaction_path(transaction), text: 'Destroy'
    end
  end

  it 'renders pagination' do
    render

    assert_select '.d-flex.justify-content-center.mt-3'
  end

  it 'renders new transaction and export CSV buttons' do
    render

    assert_select 'a[href=?]', new_transaction_path, text: 'New Transaction'
    assert_select 'a[href=?]', transactions_path(format: :csv), text: 'Export CSV'
  end
end
