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
class Deal < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :item

  monetize :price_cents, as: :price

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  # before vat
  def deal_amount
    quantity * price
  end

  def vat
    deal_amount * item.vat / 100
  end

  # after vat
  def total_price
    vat + deal_amount
  end
end
