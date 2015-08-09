Rails.application.routes.draw do

  get "/signup", to: "users#new", as: :signup
  get "/profile", to: "users#show", as: :profile
  resources :users, only: [:create]

  get "/login", to: "sessions#new", as: :login
  get "logout", to: "sessions#destroy", as: :logout
  resources :sessions, only: [:create]

  resources :thoughts

  resources :pages, only: [:about]

  root "pages#index"

end