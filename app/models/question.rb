class Question < ApplicationRecord
  has_many :prompts, dependent: :destroy
  has_one :toss_up, -> { where(type: "TossUp") }, class_name: "Prompt"
  has_one :bonus, -> { where(type: "Bonus") }, class_name: "Prompt"

  validates :title, presence: true

  accepts_nested_attributes_for :prompts, allow_destroy: true
end
