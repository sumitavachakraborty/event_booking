require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_presence_of(:total_price) }
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:event) }
    it { should belong_to(:ticket) }
  end

  describe 'callbacks' do
    it 'should call send_confirmation_email after create' do
      booking = build(:booking)
      expect(SendBookingConfirmationWorker).to receive(:perform_async).with(kind_of(Integer))
      booking.save
    end
  end
end