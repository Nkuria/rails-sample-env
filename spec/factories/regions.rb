FactoryBot.define do
  factory :region do
    name { Faker::Address.full_address }
    company
  end
end
