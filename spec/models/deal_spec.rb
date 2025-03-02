# frozen_string_literal: true

# == Schema Information
#
# Table name: deals
#
#  id             :integer          not null, primary key
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("KES"), not null
#  quantity       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer          not null
#  transaction_id :integer          not null
#
# Indexes
#
#  index_deals_on_item_id         (item_id)
#  index_deals_on_transaction_id  (transaction_id)
#
# Foreign Keys
#
#  item_id         (item_id => items.id)
#  transaction_id  (transaction_id => transactions.id)
#
require 'rails_helper'

RSpec.describe Deal, type: :model do
  let(:item) { create(:item, vat: 10) } # Assuming VAT is 10%
  let(:transaction) { create(:transaction) }
  let(:deal) { build(:deal, item: item, txn: transaction, price_cents: 1000, quantity: 2) }

  describe 'associations' do
    it 'belongs to a transaction' do
      assoc = described_class.reflect_on_association(:txn)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:foreign_key]).to eq('transaction_id')
    end

    it 'belongs to an item' do
      assoc = described_class.reflect_on_association(:item)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is invalid if quantity is less than 1' do
      deal.quantity = 0
      expect(deal).not_to be_valid
      expect(deal.errors[:quantity]).to include('must be greater than or equal to 1')
    end

    it 'is valid if quantity is at least 1' do
      deal.quantity = 1
      expect(deal).to be_valid
    end
  end

  describe 'monetization' do
    it 'responds to price' do
      expect(deal).to respond_to(:price)
    end
  end

  describe 'instance methods' do
    it '#deal_amount calculates the total before VAT' do
      expect(deal.deal_amount).to eq(Money.new(2000, 'KES')) # 2 * 10.00 in cents
    end

    it '#vat calculates the VAT amount' do
      expect(deal.vat).to eq(Money.new(200, 'KES')) # 10% of 20.00 in cents
    end

    it '#total_price calculates the total after VAT' do
      expect(deal.total_price).to eq(Money.new(2200.00)) # 20.00 + 2.00 in cents
    end
  end

  describe 'factory' do
    it 'is valid with valid attributes' do
      expect(deal).to be_valid
    end
  end
end
