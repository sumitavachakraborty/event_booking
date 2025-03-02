class Api::V1::EventOrganizersController < ApplicationController
    before_action :authorize_event_organizer, except: [:create]
    before_action :set_event_organizer, only: [:show, :update]
    
    def create
      @event_organizer = EventOrganizer.new(event_organizer_params)
      
      if @event_organizer.save
        token = JsonWebToken.encode(user_id: @event_organizer.id, user_type: 'EventOrganizer')
        render json: { token: token, event_organizer: @event_organizer }, status: :created
      else
        render json: { errors: @event_organizer.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def show
      render json: @event_organizer
    end
    
    def update
      if @event_organizer.id == @current_user.id
        if @event_organizer.update(event_organizer_params)
          render json: @event_organizer
        else
          render json: { errors: @event_organizer.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Not authorized to update this profile' }, status: :forbidden
      end
    end
    
    private
    
    def set_event_organizer
      @event_organizer = EventOrganizer.find(params[:id])
    end
    
    def event_organizer_params
      params.require(:event_organizer).permit(:name, :email, :password, :password_confirmation)
    end
end