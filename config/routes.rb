Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update]
      resources :meals, only: [:create, :show, :update, :delete]
      resources :food_items, only: [:create, :show]
      resources :compounds, only: [:create, :show]
      resources :meal_types, only: [:show]
      resources :meal_food_items, only: [:create, :update, :delete]
      resources :food_item_compounds, only: [:create]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
    end
  end
end
