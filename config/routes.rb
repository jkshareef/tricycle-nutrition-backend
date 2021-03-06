Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update]
      resources :meals, only: [:create, :show, :update, :destroy]
      resources :food_items, only: [:create, :show]
      resources :compounds, only: [:create, :show]
      resources :meal_types, only: [:show]
      resources :meal_food_items, only: [:create, :update, :destroy]
      resources :food_item_compounds, only: [:create]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      get '/food/recent', to: 'meals#get_recent'
      get '/food/:time', to: 'meals#get_food'
      post '/add/:query', to: 'meals#add_food'
      get '/foodnames', to: 'food_items#food_names'
      post '/photo', to: 'photos#computer_vision'
    end
  end
end
