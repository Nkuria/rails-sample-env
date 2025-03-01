# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string
#  vat        :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
# Indexes
#
#  index_items_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
FactoryBot.define do
  factory :item do
    name { 'MyString' }
    vat { '9.99' }
    company { nil }
  end
end
