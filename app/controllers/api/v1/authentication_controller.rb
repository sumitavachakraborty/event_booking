class Api::V1::AuthenticationController < ApplicationController
    def login
      user_type = params[:user_type]
      email = params[:email]
      password = params[:password]
      if user_type == 'event_organizer'
        user = EventOrganizer.find_by_email(email)
      elsif user_type == 'customer'
        user = Customer.find_by_email(email)
      else
        render json: { error: 'Invalid user type' }, status: :unprocessable_entity
        return
      end
      
      if user&.authenticate(password)
        token = JsonWebToken.encode(user_id: user.id, user_type: user.class.name)
        render json: { token: token, user_type: user.class.name, user_id: user.id }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end
end