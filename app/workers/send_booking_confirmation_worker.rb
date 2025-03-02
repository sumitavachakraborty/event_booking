class SendBookingConfirmationWorker
    include Sidekiq::Worker
    
    def perform(booking_id)
      booking = Booking.find(booking_id)
      customer = booking.customer
      event = booking.event
      
      puts "Sending booking confirmation email to #{customer.email} for #{event.title}"
      
      Rails.logger.info "Booking confirmation email sent to #{customer.email} for event: #{event.title}"
    end
end
  