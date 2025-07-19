class Room < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :games, dependent: :destroy
  has_one :current_game, -> { where(status: ['reading', 'paused']) }, class_name: 'Game'

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, if: -> { code.blank? }

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end