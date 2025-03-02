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
class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_many :deals, foreign_key: "transaction_id", dependent: :destroy

  monetize :amount_cents, as: :amount

  accepts_nested_attributes_for :deals, allow_destroy: true

  def self.ransackable_attributes(auth_object = nil)
    ["amount_cents", "amount_currency", "created_at", "customer_id", "id", "updated_at", "user_id"]
  end

  def total_vat
    deals.sum { |x| x.vat }
  end

  # before vat
  def transaction_amount
    deals.sum { |x| x.deal_amount }
  end

  # after vat
  def total_amount
    deals.sum { |x| x.total_price }
  end
end
