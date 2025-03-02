# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/new', type: :view do
  before(:each) do
    @user = create(:user, name: 'John Doe')
    @customer = create(:customer, name: 'Acme Corp')
    assign(:transaction, Transaction.new)
    assign(:users, [@user])
    assign(:customers, [@customer])
  end

  it 'renders the new transaction form' do
    render

    assert_select 'form[action=?][method=?]', transactions_path, 'post' do
      assert_select 'select[name=?]', 'transaction[user_id]'
      assert_select 'select[name=?]', 'transaction[customer_id]'
      assert_select 'input[name=?]', 'transaction[amount]'
    end
  end

  it 'renders the Deals section' do
    render

    assert_select 'h5', text: 'Deals'
    assert_select '#deals-fields'
    assert_select 'a.add-deal', text: 'Add Deal'
  end

  it 'renders the Back button' do
    render

    assert_select 'a[href=?][class=?]', transactions_path, 'btn btn-outline-secondary btn-sm', text: 'Back'
  end
end
