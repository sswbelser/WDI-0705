#README

Weekend lab to practice created a blog app.

#Starting the Project

```$ rails new blog -T -d postgresql```<br>
```$ cd blog```<br>
```$ git init``` (and add, commit, remote, push)

#config/routes.rb
```Rails.application.routes.draw do```
	```get "/signup", to: "users#new"```
	```get "/profile", to: "users#show"```
	```resources :users, only: [:create]```
	```get "/login", to: "sessions#new"```
	```get "logout", to: "sessions#destroy"```
	```resources :users, only: [:create]```
	```resources :thoughts, except: [:index]```
	```root "thoughts#index"```
```end```

#Terminal
```$ rake db:create```

```$ rake routes```
