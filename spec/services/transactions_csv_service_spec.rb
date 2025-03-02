# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe TransactionsCsvService do
  describe '.generate' do
    let(:user) { create(:user, name: 'John Doe') }
    let(:customer) { create(:customer, name: 'Jane Smith') }
    let(:transaction) do
      create(:transaction, user: user, customer: customer, created_at: Time.zone.local(2024, 3, 1, 12, 0, 0))
    end

    before do
      allow(transaction).to receive(:total_amount).and_return(1500.50)
    end

    it 'generates a CSV with correct headers' do
      csv_data = described_class.generate([transaction])
      csv = CSV.parse(csv_data, headers: true)

      expect(csv.headers).to eq(['User', 'Customer', 'Amount', 'Created At'])
    end

    it 'includes transaction details in the CSV' do
      csv_data = described_class.generate([transaction])
      csv = CSV.parse(csv_data, headers: true)

      expect(csv[0]['User']).to eq('John Doe')
      expect(csv[0]['Customer']).to eq('Jane Smith')
      expect(csv[0]['Amount']).to eq('1500.5')
    end
  end
end
