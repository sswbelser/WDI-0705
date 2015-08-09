#README
Weekend lab to practice created a blog app.

#Starting the Project
```$ rails new blog -T -d postgresql```<br>
```$ cd blog```<br>
```$ git init``` (and add, commit, remote, and push)

#config/routes.rb
```
Rails.application.routes.draw do
  get "/signup", to: "users#new", as: :signup
  get "/profile", to: "users#show", as: :profile
  resources :users, except: [:new, :show]

  get "/login", to: "sessions#new", as: :login
  get "logout", to: "sessions#destroy", as: :logout
  resources :users, only: [:create]

  resources :thoughts

  resources :pages, only: [:about]

  root "pages#index"
end
```

#Terminal
```$ rake db:create```<br>
```$ rake routes```<br>
```$ rails g controller pages index about```<br>
```$ rails g controller sessions new create```<br>
```$ rails g controller users new create update edit destroy index show```<br>
```$ rails g controller thoughts new create update edit destroy index show```<br>
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

#app/models/user.rb
```
class User < ActiveRecord::Base
	has_many :thoughts, dependent: :destroy
end
```

#app/models/thought.rb
```
class Thought < ActiveRecord::Base
	belongs_to :user
end
```

#app/controllers/users_controller.rb
```
class UsersController < ApplicationController
  before_filter :authorize, only: [:show]

  def new
    # redirect user if already logged in
    if current_user
      redirect_to profile_path
    else
      @user = User.new
      render :new
    end
  end

  def create
    # redirect user if already logged in
    if current_user
      redirect_to profile_path
    else
      user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        flash[:notice] = "Successfully signed up."
        # redirect_to "/profile"
        # refactored with route helpers:
        redirect_to profile_path
      else
        flash[:error] = user.errors.full_messages.join(', ')
        # redirect_to "/signup"
        # refactored with route helpers:
        redirect_to signup_path
      end
    end
  end

  def show
    render :show
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
```