class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :customer, null: false, foreign_key: true, index: true
      t.monetize :amount

      t.timestamps
    end
  end
end
