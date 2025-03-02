class Api::V1::EventsController < ApplicationController
    before_action :authorize_event_organizer, except: [:index, :show]
    before_action :authorize_request, only: [:index, :show]
    before_action :set_event, only: [:show, :update, :destroy]
    
    def index
      if @current_user.is_a?(EventOrganizer)
        @events = @current_user.events
      else
        @events = Event.all
      end
      
      render json: @events
    end
    
    def show
      render json: @event, include: ['tickets']
    end
    
    def create
      @event = @current_user.events.new(event_params)
      
      if @event.save
        render json: @event, status: :created
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def update
      if @event.event_organizer_id == @current_user.id
        if @event.update(event_params)
          render json: @event
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Not authorized to update this event' }, status: :forbidden
      end
    end
    
    def destroy
      if @event.event_organizer_id == @current_user.id
        @event.destroy
        head :no_content
      else
        render json: { error: 'Not authorized to delete this event' }, status: :forbidden
      end
    end
    
    private
    
    def set_event
      @event = Event.find(params[:id])
    end
    
    def event_params
      params.require(:event).permit(:title, :description, :venue, :event_date)
    end
end