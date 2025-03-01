class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :survey, foreign_key: true
      t.references :question, foreign_key: true, null: true
      t.string :answer, default: '', null: false
      t.timestamps
    end
  end
end
