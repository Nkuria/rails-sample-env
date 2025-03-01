class CreateSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :surveys do |t|
      t.references :company, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :user, foreign_key: true
      t.text :note, default: '', null: false
      t.timestamps
    end
  end
end
