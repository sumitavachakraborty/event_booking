class Api::V1::CustomersController < ApplicationController
    before_action :authorize_customer, except: [:create]
    before_action :set_customer, only: [:show, :update]
    
    def create
        debugger
      @customer = Customer.new(customer_params)
      debugger      
      if @customer.save
        token = JsonWebToken.encode(user_id: @customer.id, user_type: 'Customer')
        render json: { token: token, customer: @customer }, status: :created
      else
        render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def show    
      render json: @customer
    end
    
    def update
      if @customer.id == @current_user.id
        if @customer.update(customer_params)
          render json: @customer
        else
          render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Not authorized to update this profile' }, status: :forbidden
      end
    end
    
    private
    
    def set_customer
      @customer = Customer.find(params[:id])
    end
    
    def customer_params
      params.require(:customer).permit(:name, :email, :password, :password_confirmation)
    end
end