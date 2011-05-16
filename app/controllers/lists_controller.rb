class ListsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  def new
    @list = current_user.lists.build
  end
  
  def create
    @list = current_user.lists.create(params[:list])
    redirect_to list_films_path(@list)
  end
  
  def index
    @lists = List.all
  end  
end