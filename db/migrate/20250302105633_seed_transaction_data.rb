class SeedTransactionData < ActiveRecord::Migration[6.1]
  def up
    require 'faker'

    # Create Companies
    companies = Array.new(5) { Company.create!(name: Faker::Company.name) }

    # Create Regions
    regions = companies.map { |company| Region.create!(company: company, name: Faker::Address.state) }

    # Create Customers
    customers = companies.flat_map do |company|
      Array.new(30) { Customer.create!(company: company, name: Faker::Name.name, region: regions.sample) }
    end

    # Create Users
    users = companies.flat_map do |company|
      Array.new(5) do
        User.create!(company: company, name: Faker::Name.name, api_key: SecureRandom.hex, api_secret: SecureRandom.hex)
      end
    end

    # Create Items
    items = companies.flat_map do |company|
      Array.new(50) { Item.create!(company: company, name: Faker::Commerce.product_name, vat: rand(0.05..0.20)) }
    end

    # Create Transactions
    200.times do
      transaction = Transaction.create!(
        user: users.sample,
        customer: customers.sample,
        amount_cents: rand(1000..10_000),
        amount_currency: 'KES'
      )

      # Create Deals for each Transaction
      rand(1..5).times do
        item = items.sample
        quantity = rand(1..10)
        price_cents = rand(100..1000)

        Deal.create!(
          txn: transaction,
          item: item,
          price_cents: price_cents,
          price_currency: 'KES',
          quantity: quantity
        )
      end
    end
  end

  def down
    Deal.delete_all
    Transaction.delete_all
    Item.delete_all
    User.delete_all
    Customer.delete_all
    Region.delete_all
    Company.delete_all
  end
end
