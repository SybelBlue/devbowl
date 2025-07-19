class Game < ApplicationRecord
  belongs_to :room
  belongs_to :current_question, class_name: 'Question', optional: true
  has_many :buzzes, dependent: :destroy

  enum :status, { waiting: 0, reading: 1, paused: 2, completed: 3 }
end
