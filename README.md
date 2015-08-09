#README
Weekend lab to practice created a blog app.

#Starting the Project
```$ rails new blog -T -d postgresql```<br>
```$ cd blog```<br>
```$ git init``` (and add, commit, remote, and push)

#config/routes.rb
```
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
```

#Terminal
```$ rake db:create```<br>
```$ rake routes```<br>
```$ rails g controller users new create show```<br>
```$ rails g controller thoughts 
```$ rails g model User first_name last_name email password_digest```<br>
```$ rails g model Thought title body```<br>

#app/views/layouts/application.html.erb
```
<!DOCTYPE html>
<html>
<head>
	<title>Blog</title>

	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">

	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

	<%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
	<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
	<%= csrf_meta_tags %>
</head>
<body>

<%= yield %>

</body>
</html>
```
