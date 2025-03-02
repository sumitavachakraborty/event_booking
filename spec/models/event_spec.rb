require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:venue) }
    it { should validate_presence_of(:event_date) }
  end

  describe 'associations' do
    it { should belong_to(:event_organizer) }
    it { should have_many(:tickets).dependent(:destroy) }
    it { should have_many(:bookings).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'should call notify_customers after update' do
      event = create(:event)
      expect(NotifyCustomersWorker).to receive(:perform_async).with(event.id)
      event.update(title: 'New Title')
    end
  end
end