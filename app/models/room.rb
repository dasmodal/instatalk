class Room < ApplicationRecord
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.hex(2)
  end
end
