class CreateDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :deals do |t|
      t.references :transaction, null: false, foreign_key: true, index: true
      t.references :item, null: false, foreign_key: true, index: true
      t.monetize :price
      t.integer :quantity

      t.timestamps
    end
  end
end
