# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:company) { create(:company) }

  describe 'associations' do
    it 'belongs to a company' do
      item = described_class.reflect_on_association(:company)
      expect(item.macro).to eq(:belongs_to)
    end

    it 'has many deals with dependent destroy' do
      item = described_class.reflect_on_association(:deals)
      expect(item.macro).to eq(:has_many)
      expect(item.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      item = build(:item, name: nil)
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a VAT' do
      item = build(:item, vat: nil)
      expect(item).not_to be_valid
      expect(item.errors[:vat]).to include("can't be blank")
    end

    it 'is invalid if VAT is below 0' do
      item = build(:item, vat: -1)
      expect(item).not_to be_valid
      expect(item.errors[:vat]).to include('must be greater than or equal to 0')
    end

    it 'is invalid if VAT is above 100' do
      item = build(:item, vat: 101)
      expect(item).not_to be_valid
      expect(item.errors[:vat]).to include('must be less than or equal to 100')
    end

    it 'is valid with a VAT between 0 and 100' do
      item = build(:item, vat: 50)
      expect(item).to be_valid
    end
  end

  describe 'factory' do
    it 'is valid with valid attributes' do
      item = build(:item, company: company)
      expect(item).to be_valid
    end
  end
end
