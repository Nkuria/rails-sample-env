FactoryBot.define do
  factory :region do
    name { Faker::Address.full_addres }
    company
  end
end
