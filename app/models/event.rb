class Event < ApplicationRecord
  belongs_to :event_organizer
  has_many :tickets, dependent: :destroy
  has_many :bookings, dependent: :destroy
  
  validates :title, presence: true
  validates :venue, presence: true
  validates :event_date, presence: true
  
  after_update :notify_customers
  
  private
  
  def notify_customers
    NotifyCustomersWorker.perform_async(self.id)
  end
end