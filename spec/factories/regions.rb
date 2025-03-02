# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  parent_id  :integer
#
# Indexes
#
#  index_regions_on_company_id  (company_id)
#  index_regions_on_parent_id   (parent_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#  parent_id   (parent_id => regions.id)
#
FactoryBot.define do
  factory :region do
    name { Faker::Address.full_address }
    company
  end
end
