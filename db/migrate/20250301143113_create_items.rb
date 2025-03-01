class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :vat
      t.references :company, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
