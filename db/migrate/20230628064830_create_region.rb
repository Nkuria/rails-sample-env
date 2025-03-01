class CreateRegion < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.references :company, index: true, foreign_key: true, null: false
      t.string :name, default: '', null: false
      t.references :parent, index: true, foreign_key: { to_table: :regions }, null: true
      t.timestamps
    end
  end
end
