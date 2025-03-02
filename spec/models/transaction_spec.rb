# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("KES"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :integer          not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_transactions_on_customer_id  (customer_id)
#  index_transactions_on_user_id      (user_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#  user_id      (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }
  let(:transaction) { build(:transaction, user: user, customer: customer) }

  describe 'associations' do
    it 'belongs to a user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'belongs to a customer' do
      assoc = described_class.reflect_on_association(:customer)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'has many deals with dependent destroy' do
      assoc = described_class.reflect_on_association(:deals)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    it 'is invalid if created_at is in the future' do
      transaction.created_at = 1.day.from_now
      expect(transaction).not_to be_valid
      expect(transaction.errors[:created_at]).to include('cannot be in the future')
    end

    it 'is valid if created_at is in the past or present' do
      transaction.created_at = Time.current
      expect(transaction).to be_valid
    end
  end

  describe 'monetize' do
    it 'responds to amount' do
      expect(transaction).to respond_to(:amount)
    end
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for deals' do
      expect(Transaction.nested_attributes_options).to include(:deals)
    end
  end

  describe 'ransackable attributes' do
    it 'returns the correct searchable attributes' do
      expect(Transaction.ransackable_attributes).to match_array(
        %w[amount_cents amount_currency created_at customer_id id updated_at user_id]
      )
    end
  end

  describe 'instance methods' do
    let(:deal1) { double('Deal', vat: 10, deal_amount: 100, total_price: 110) }
    let(:deal2) { double('Deal', vat: 5, deal_amount: 200, total_price: 205) }

    before do
      allow(transaction).to receive(:deals).and_return([deal1, deal2])
    end

    it '#total_vat calculates the sum of VAT' do
      expect(transaction.total_vat).to eq(15)
    end

    it '#transaction_amount calculates the total before VAT' do
      expect(transaction.transaction_amount).to eq(300)
    end

    it '#total_amount calculates the total after VAT' do
      expect(transaction.total_amount).to eq(315)
    end
  end

  describe 'factory' do
    it 'is valid with valid attributes' do
      expect(transaction).to be_valid
    end
  end
end
