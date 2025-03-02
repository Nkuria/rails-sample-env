# == Schema Information
#
# Table name: companies
#
#  id                      :integer          not null, primary key
#  daily_request_limit_api :integer          default(100)
#  name                    :string           default(""), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :company do
    name { Faker::Name.name }
    daily_request_limit_api { 50 }
  end
end
