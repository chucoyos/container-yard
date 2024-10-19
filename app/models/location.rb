class Location < ApplicationRecord
  has_many :moves
  validates :location, presence: true

  scope :available, -> { where(available: true) }

  def full_description
    location
  end
end
