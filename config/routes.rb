Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      
      resources :event_organizers, only: [:create, :show, :update]
      resources :customers, only: [:create, :show, :update]
      
      resources :events do
        resources :tickets, only: [:index, :create, :update, :destroy]
      end
      
      resources :bookings, only: [:index, :show, :create]
    end
  end
end