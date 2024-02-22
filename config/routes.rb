Rails.application.routes.draw do
  root "photos#index"

  devise_for :users
  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  # if I wanted "/users/:id", could specify the path in either of the two ways described
  # 1. get "/users/:id" => "users#show", as: :user
  # 2. resources :users, only: :show

  get "/:username" => "users#show", as: :user

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end
