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
```$ rails g controller users new create show```<br>
```$ rails g controller thoughts new create update edit destroy index show```<br>
```$ rails g model User first_name last_name email password_digest```<br>
```$ rails g model Thought title body```<br>
```$ rake db:migrate```<br>

#Gemfile
```gem 'bcrypt', '~> 3.1.7'```

#Terminal
```$ bundle install```

#app/models/user.rb
```
class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_secure_password

  validates :password, length: { minimum: 6 }, on: :create

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /@/,
      message: "not a valid format"
    }

end
```

#app/models/thought.rb
```
class Thought < ActiveRecord::Base
	belongs_to :user
end
```

#app/controllers/application_controller.rb
```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # find current logged-in user if session[:user_id] is set
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  # allows us to use `current_user` in views
  helper_method :current_user

  # used to require logging in before certain actions
  # look in the users_controller for an example
  def authorize
    unless current_user
      flash[:error] = "You must be logged in to do that."
      redirect_to login_path
    end
  end

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

#app/controllers/sessions_controller.rb
```
class SessionsController < ApplicationController

  def new
    # redirect user if already logged in
    if current_user
      redirect_to profile_path
    else
      render :new
    end
  end

  def create
    user = User.find_by_email(user_params[:email])
    # if user exists AND password entered is correct
    if user && user.authenticate(user_params[:password])
      # save user id to session to keep them logged in
      # when they navigate around our site
      session[:user_id] = user.id
      flash[:notice] = "Successfully logged in."
      redirect_to profile_path
    else
      # if user's login doesn't work, send them back to the login form
      flash[:error] = "Incorrect email or password. Please try again."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Successfully logged out."
    redirect_to login_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

end
```

#app/controllers/pages_controller.rb
```
class SiteController < ApplicationController
	def index
		render :index
	end
end
```

#app/views/layouts/application.html.erb
```
<!DOCTYPE html>
<html>
<head>
	<title>Rails Blog</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
	<%= csrf_meta_tags %>

	<!-- bootstrap css -->
	<link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">

  <%= stylesheet_link_tag :application, media: :all %>
</head>
<body>

<nav class="navbar navbar-default">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="/">Rails Blog</a>
    </div>
  </div><!-- /.container-fluid -->
</nav>

  <div class="container text-center">
    <% flash.each do |name, msg| %>
      <%= content_tag :div, msg, class: "alert #{name == 'error' ? 'alert-danger' : 'alert-info'}" %>
    <% end %>
    <div class="row">
      <div class="col-md-6 col-md-offset-3">
        <%= yield %>
      </div>
    </div>
    <hr>
    <p>Current user: <%= current_user.email if current_user %></p>
  </div>
  <%= javascript_include_tag :application %>

  <!-- bootstrap js -->
  <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

</body>
</html>
```

#app/views/pages/index.html.erb
```
<h1>Landing Page</h1>
<hr>
<% if current_user %>
	<p>Hello, <strong><%= current_user.email %></strong>. You are currently logged in. <%= link_to "Log out", logout_path %></p>
<% else %>
	<p>
		<!-- refactored with rails helpers: -->
		<%= link_to "Sign Up", signup_path, class: "btn btn-warning" %>
		&nbsp; or &nbsp;
		<%= link_to "Log In", login_path, class: "btn btn-warning" %>
	</p>
<% end %>
```

#app/views/pages/sessions/new.html.erb
```
<h1>Log In</h1>
<hr>
<%= form_for :user, url: sessions_path do |f| %>
  <div class="form-group">
    <%= f.email_field :email, placeholder: "Email", class: "form-control", autofocus: true %>
  </div>
  <div class="form-group">
    <%= f.password_field :password, placeholder: "Password", class: "form-control" %>
  </div>
  <%= f.submit "Log In", class: "btn btn-warning" %>
<% end %>
<br>
<p>Don't have an account? <%= link_to "Click here", signup_path%> to sign up.</p>
```

#app/views/pages/users/new.html.erb
```
<h1>Sign Up</h1>
<hr>
<%= form_for @user do |f| %>
  <div class="form-group">
    <%= f.email_field :email, placeholder: "Email", class: "form-control", autofocus: true %>
  </div>
  <div class="form-group">
    <%= f.password_field :password, placeholder: "Password", class: "form-control" %>
  </div>
  <div class="form-group">
    <%= f.password_field :password_confirmation, placeholder: "Password Confirmation", class: "form-control" %>
  </div>
  <%= f.submit "Sign Up", class: "btn btn-warning" %>
<% end %>
<br>
<p>Already have an account? <%= link_to "Click here", login_path%> to log in.</p>
```

#app/views/pages/users/show.html.erb
```
<h3>Welcome, <%= current_user.email %>!</h3>
<hr>
<p>You are currently logged in. <%= link_to "Log out", logout_path %></p>
```