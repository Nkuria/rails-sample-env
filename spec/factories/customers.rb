FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    company
    region
  end
end
