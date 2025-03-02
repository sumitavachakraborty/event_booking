class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :event
  belongs_to :ticket
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  after_create :send_confirmation_email
  
  private
  
  def send_confirmation_email
    SendBookingConfirmationWorker.perform_async(self.id)
  end
end