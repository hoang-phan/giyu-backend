Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
      resources :orders, only: %i[index show create update destroy] do
        member do
          post :transition_status
        end
      end
      resources :line_items
      resources :products
      resources :ice_creams
      resources :flavors
      resources :toppings
      resources :ice_cream_flavors
    end
  end
end
