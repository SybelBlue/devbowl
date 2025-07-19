class FixCurrentQuestionInGames < ActiveRecord::Migration[7.0]
  def change
    # Remove the existing column if it exists
    if column_exists?(:games, :current_question_id)
      remove_column :games, :current_question_id
    end

    # Add it back with proper foreign key
    add_reference :games, :current_question, null: true, foreign_key: { to_table: :questions }
  end
end