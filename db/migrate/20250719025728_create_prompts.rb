class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.references :question, null: false, foreign_key: true
      t.string :type
      t.string :format
      t.text :content
      t.text :answer
      t.text :answer_choices

      t.timestamps
    end
  end
end
