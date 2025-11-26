Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

   namespace :api do
    namespace :v1 do
      # Authentication routes
      post '/auth/login', to: 'authentication#login'
      post '/auth/register', to: 'authentication#register'

      resources :users, only: [:index]
      resources :documents, only: [:index, :show, :update, :destroy] do
        collection do
          get 'search'
        end
      end

      resources :categories, only: [:index]
      resources :documents_categories, only: [:index]
    end
  end
end
