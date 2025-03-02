class NotifyCustomersWorker
    include Sidekiq::Worker
    
    def perform(event_id)
      event = Event.find(event_id)
      bookings = event.bookings
      
      customers = bookings.map(&:customer).uniq
      
      customers.each do |customer|
        puts "Sending event update notification to #{customer.email} for #{event.title}"
        
        Rails.logger.info "Event update notification sent to #{customer.email} for event: #{event.title}"
      end
    end
end