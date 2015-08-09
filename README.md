#README

Weekend lab to practice created a blog app.

#Starting the Project

```$ rails new blog -T -d postgresql```<br>
```$ cd blog```<br>
```$ git init``` (and add, commit, remote, push)

#config/routes.rb
```Rails.application.routes.draw do<br>
	get "/signup", to: "users#new"<br>
	get "/profile", to: "users#show"<br>
	resources :users, only: [:create]<br>
	get "/login", to: "sessions#new"<br>
	get "logout", to: "sessions#destroy"<br>
	resources :users, only: [:create]<br>
	resources :thoughts, except: [:index]<br>
	root "thoughts#index"<br>
end```

#Terminal
```$ rake db:create```

```$ rake routes```
