class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :room, null: false, foreign_key: true
      t.references :current_question, null: false, foreign_key: true
      t.string :status
      t.string :current_reader

      t.timestamps
    end
  end
end
