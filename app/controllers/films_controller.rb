class FilmsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :load_and_authorize_list, :only => [:new, :create]
  
  def new
    @film = @list.films.build
    @film.projections.build
  end
  
  def create
    @list.films.create(params[:film])
    redirect_to list_films_path(@list)
  end
  
  def show
    @film = Film.find(params[:id])
    respond_to do |format|
      format.html{ redirect_to @film.trailer_url }
      format.js
    end
  end
  
  def index
    @list = List.find(params[:list_id])
    @films = @list.films.order("imdb_rating DESC")
    @bookmarked_films = current_user.present? ? current_user.films.to_a : []
  end
  
  def edit
    @film = Film.find(params[:id])
    @list = @film.list
    redirect_to list_films_path(@list), :alert => "You don't have access to modify this list" and return false unless ENV['edit'] == 'on'
  end
  
  def update
    @film = Film.find(params[:id])
    @list = @film.list
    redirect_to list_films_path(@list), :alert => "You don't have access to modify this list" and return false unless ENV['edit'] == 'on'
    @film.update_attributes(params["film"])
    redirect_to list_films_path(@list)
  end
  
  def destroy
    @film = Film.find(params[:id])
    @list = @film.list
    redirect_to list_films_path(@list), :alert => "You don't have access to modify this list" and return false unless ENV['edit'] == 'on'
    @film.destroy
    redirect_to list_films_path(@list)
  end
  
  protected
  
  def load_and_authorize_list
    @list = List.find(params[:list_id])
    redirect_to list_films_path(@list), :alert => "You don't have access to modify this list" and return false unless @ENV['edit'] == 'on'
  end
end
