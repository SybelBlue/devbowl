class Prompt < ApplicationRecord
  belongs_to :question

  # Enable STI
  self.inheritance_column = "type"

  # Basic validations
  validates :content, presence: true
  validates :answer, presence: true
  validates :format, inclusion: { in: %w[MultipleChoice ShortAnswer UmActually] }

  # Format-specific validations
  validates :answer_choices, if: -> { format == "MultipleChoice" }, presence: true, length: { is: 4 }
  validates :answer, if: -> { format == "MultipleChoice" }, inclusion: { in: %w[W X Y Z] }

  validates :answer, if: -> { format == "UmActually" }, format: { with: /\AUm, actually[,:]/i }
end
