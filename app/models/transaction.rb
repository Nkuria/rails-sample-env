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
  has_many :deals, dependent: :destroy

  monetize :amount
end
