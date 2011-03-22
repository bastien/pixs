class FilmsController < ApplicationController

  def index
    @films = Film.order("imdb_rating DESC")
  end
  
  def edit
    if @film.imdb_url.nil?
      @film = Film.find(params[:id])
    else
      redirect_to films_path
    end
  end
  
  def update
    @film = Film.find(params[:id])
    if @film.imdb_url.nil?
      @film.update_attributes(:imdb_url => params["film"]["imdb_url"])
    end
    redirect_to films_path
  end
  
end
