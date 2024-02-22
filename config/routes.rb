Rails.application.routes.draw do
  root "photos#index"

  get "/users/:id" => "users#show", as: :user

  devise_for :users
  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end
