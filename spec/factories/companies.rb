FactoryBot.define do
  factory :company do
    name { Faker::Name.name  }
    daily_request_limit_api { 50 }
  end
end
