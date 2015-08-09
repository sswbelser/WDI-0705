Rails.application.routes.draw do

  get 'users/new'

  get 'users/create'

  get 'users/update'

  get 'users/edit'

  get 'users/destroy'

  get 'users/index'

  get 'users/show'

  get "/signup", to: "users#new"
  get "/profile", to: "users#show"
  resources :users, except: [:new, :show]

  get "/login", to: "sessions#new"
  get "logout", to: "sessions#destroy"
  resources :users, only: [:create]

  resources :thoughts, except: [:index]

  root "thoughts#index"

end