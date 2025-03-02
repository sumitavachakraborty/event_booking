class Api::V1::BookingsController < ApplicationController
    before_action :authorize_customer
    
    def index
      @bookings = @current_user.bookings
      render json: @bookings, include: ['event', 'ticket']
    end
    
    def show
      @booking = @current_user.bookings.find(params[:id])
      render json: @booking, include: ['event', 'ticket']
    end
    
    def create
      ActiveRecord::Base.transaction do
        @event = Event.find(booking_params[:event_id])
        @ticket = @event.tickets.find(booking_params[:ticket_id])
        
        if @ticket.quantity_available < booking_params[:quantity].to_i
          raise ActiveRecord::Rollback
          return render json: { error: 'Not enough tickets available' }, status: :unprocessable_entity
        end
        total_price = @ticket.price * booking_params[:quantity].to_i
        
        @booking = @current_user.bookings.new(
          event_id: @event.id,
          ticket_id: @ticket.id,
          quantity: booking_params[:quantity],
          total_price: total_price
        )
        
        unless @booking.save
          raise ActiveRecord::Rollback
          return render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
        
        @ticket.quantity_available -= booking_params[:quantity].to_i
        unless @ticket.save
          raise ActiveRecord::Rollback
          return render json: { error: 'Failed to update ticket availability' }, status: :unprocessable_entity
        end
        
        render json: @booking, status: :created
      end
    end
    
    private
    
    def booking_params
      params.require(:booking).permit(:event_id, :ticket_id, :quantity)
    end
end