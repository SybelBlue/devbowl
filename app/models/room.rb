class Room < ApplicationRecord
  has_many :users, dependent: :destroy
  has_one :current_game, -> { where(status: 'active') }, class_name: 'Game'
  has_many :games, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, if: -> { code.blank? }

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end