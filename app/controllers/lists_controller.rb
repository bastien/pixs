class ListsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    @lists = List.all
  end
  
  def new
    @list = current_user.lists.build
  end
  
  def create
    @list = current_user.lists.create(params[:list].update(:user => current_user))
    redirect_to list_films_path(@list)
  end
end