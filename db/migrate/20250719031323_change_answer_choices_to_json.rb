class ChangeAnswerChoicesToJson < ActiveRecord::Migration[8.0]
  def change
    change_column :prompts, :answer_choices, :json
  end
end
