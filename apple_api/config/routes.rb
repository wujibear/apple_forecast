Rails.application.routes.draw do
  # API Documentation
  get '/api-docs', to: 'docs#index'
  get '/docs', to: 'docs#ui'
  
  # API routes
  namespace :api do
    namespace :v1 do
      resource :session, only: [ :create, :destroy ]
      resources :passwords, param: :token, only: [ :create, :update ]
      resource :user, only: [ :show, :update ]
      resources :redemptions, only: [ :index ]

      resources :rewards, only: [ :index, :show ] do
        member do
          post :redeem, to: "redemptions#create"
        end
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
