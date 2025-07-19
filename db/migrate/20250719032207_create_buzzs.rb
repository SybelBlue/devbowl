class CreateBuzzs < ActiveRecord::Migration[8.0]
  def change
    create_table :buzzs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :answer
      t.boolean :correct
      t.datetime :timestamp

      t.timestamps
    end
  end
end
