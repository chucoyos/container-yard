class Role < ApplicationRecord
  has_and_belongs_to_many :permissions
  has_many :users
  validates :name, presence: true, uniqueness: true
end
