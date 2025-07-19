class Buzz < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :question
end
