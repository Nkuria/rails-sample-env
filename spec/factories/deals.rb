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
FactoryBot.define do
  factory :deal do
    txn factory: :transaction
    item
    price { Faker::Number.between(from: 1, to: 10000) }
    quantity { Faker::Number.between(from: 1, to: 30) }
  end
end
