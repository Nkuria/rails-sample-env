FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    company
  end
end
