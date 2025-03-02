class ApplicationController < ActionController::API
    include ActionController::Serialization
  
    def authorize_request
        header = request.headers['Authorization']
        if header.nil?
          render json: { errors: 'Missing token' }, status: :unauthorized and return
        end
    
        token = header.split(' ').last
        begin
          @decoded = JsonWebToken.decode(token)
          @current_user = find_user(@decoded)
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized and return
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized and return
        end
    end
    
    def authorize_event_organizer
      authorize_request
      unless @current_user.is_a?(EventOrganizer)
        render json: { errors: 'Not authorized as an event organizer' }, status: :forbidden
      end
    end
    
    def authorize_customer
      authorize_request
      unless @current_user.is_a?(Customer)
        render json: { errors: 'Not authorized as a customer' }, status: :forbidden
      end
    end
    
    private
    
    def find_user
      if @decoded[:user_type] == 'EventOrganizer'
        EventOrganizer.find(@decoded[:user_id])
      elsif @decoded[:user_type] == 'Customer'
        Customer.find(@decoded[:user_id])
      end
    end
  end