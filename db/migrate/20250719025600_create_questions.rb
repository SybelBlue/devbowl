class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :title
      t.string :category

      t.timestamps
    end
  end
end
