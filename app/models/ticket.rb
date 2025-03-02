class Ticket < ApplicationRecord
  belongs_to :event
  has_many :bookings
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, presence: true, numericality: { greater_than_or_equal_to: 0 }
end