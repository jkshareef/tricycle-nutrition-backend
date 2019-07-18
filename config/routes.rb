Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :meals, only: [:create, :edit]
      resources :food_items, only: [:create]
      resources :compounds, only: [:show]
      resources :meal_types, only: [:show]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
    end
  end
end
