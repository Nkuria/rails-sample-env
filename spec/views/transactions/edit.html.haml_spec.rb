# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/edit', type: :view do
  before(:each) do
    @user = create(:user, name: 'John Doe')
    @customer = create(:customer, name: 'Acme Corp')
    @transaction = assign(:transaction, Transaction.create!(
                                          user: @user,
                                          customer: @customer,
                                          amount_cents: 10_000
                                        ))

    assign(:users, [@user])
    assign(:customers, [@customer])
  end

  it 'renders the edit transaction form' do
    render

    assert_select 'form[action=?][method=?]', transaction_path(@transaction), 'post' do
      assert_select 'select[name=?]', 'transaction[user_id]'
      assert_select 'select[name=?]', 'transaction[customer_id]'
      assert_select 'input[name=?]', 'transaction[amount]'
    end
  end

  it 'renders the deals section' do
    render

    assert_select 'h5', text: 'Deals'
    assert_select '#deals-fields'
    assert_select 'a.add-deal', text: 'Add Deal'
  end

  it 'renders the Show and Back buttons' do
    render

    assert_select 'a[href=?][class=?]', transaction_path(@transaction), 'btn btn-outline-primary', text: 'Show'
    assert_select 'a[href=?][class=?]', transactions_path, 'btn btn-secondary', text: 'Back'
  end
end
