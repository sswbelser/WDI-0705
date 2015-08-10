class ThoughtsController < ApplicationController

  before_filter :authorize, except: [:index, :show]

  #show ALL thoughts in db
  def index
    @thoughts = Thought.all
    render :index
  end

  #form to create new thought that belongs_to the current user
  def new
    @thought = Thought.new
    render :new
  end

  #add a new thought to the db
  def create
    thought = current_user.thoughts.create(thought_params)
    redirect_to thought_path(thought)
  end

  def show
    @thought = Thought.find(params[:id])
    render :show
  end

  def edit
    @thought = Thought.find(params[:id])
    if current_user.thoughts.include?(@thought)
      render :edit
    else
      redirect_to profile_path
    end
  end

  def update
    thought = Thought.find(params[:id])
    if current_user.thoughts.include?(thought)
      thought.update_attributes(thought_params)
      redirect_to thought_path(thought)
    else
      redirect_to profile_path
    end
  end

  def destroy
    thought = Thought.find(params[:id])
    if current_user.thoughts.include?(thought)
      thought.destroy
      redirect_to profile_path
    else
      redirect_to root_path
    end
  end

  private
    def thought_params
      params.require(:thought).permit(:title, :body)
    end
end