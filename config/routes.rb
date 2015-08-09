Rails.application.routes.draw do

  get "/signup", to: "users#new"
  get "/profile", to: "users#show"
  resources :users, only: [:create]

  get "/login", to: "sessions#new"
  get "logout", to: "sessions#destroy"
  resources :users, only: [:create]

  resources :thoughts, except: [:index]

  root "thoughts#index"

end