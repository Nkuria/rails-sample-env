class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.references :company, index: true, foreign_key: true, null: false
      t.string :name, default: '', null: false
      t.timestamps
    end
  end
end
