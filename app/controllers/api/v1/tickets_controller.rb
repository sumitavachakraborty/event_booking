class Api::V1::TicketsController < ApplicationController
    before_action :authorize_event_organizer, except: [:index]
    before_action :authorize_request, only: [:index]
    before_action :set_event
    before_action :set_ticket, only: [:update, :destroy]
    before_action :check_ownership, only: [:create, :update, :destroy]
    
    def index
      @tickets = @event.tickets
      render json: @tickets
    end
    
    def create
      @ticket = @event.tickets.new(ticket_params)
      
      if @ticket.save
        render json: @ticket, status: :created
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def update
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def destroy
      @ticket.destroy
      head :no_content
    end
    
    private
    
    def set_event
      @event = Event.find(params[:event_id])
    end
    
    def set_ticket
      @ticket = @event.tickets.find(params[:id])
    end
    
    def check_ownership
      unless @event.event_organizer_id == @current_user.id
        render json: { error: 'Not authorized to modify tickets for this event' }, status: :forbidden
      end
    end
    
    def ticket_params
      params.require(:ticket).permit(:name, :price, :quantity_available)
    end
  end
  
  