require 'csv'

class TransactionsCsvService
  def self.generate(transactions)
    CSV.generate(headers: true) do |csv|
      csv << ['User', 'Customer', 'Amount', 'Created At']

      transactions.each do |transaction|
        csv << [
          transaction.user.name,
          transaction.customer.name,
          transaction.total_amount,
          transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end
  end
end
