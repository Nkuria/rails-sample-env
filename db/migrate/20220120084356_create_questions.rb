class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :company, foreign_key: true
      t.string :question, default: '', null: false
      t.timestamps
    end
  end
end
