class FilmsController < ApplicationController
  
  def show
    @film = Film.find(params[:id])
    respond_to do |format|
      format.html{ redirect_to @film.trailer_url }
      format.js
    end
  end
  
  def index
    @films = Film.order("imdb_rating DESC")
  end
  
  #   def edit
  #     @film = Film.find(params[:id])
  #     redirect_to films_path and return unless @film.imdb_url.nil?
  #   end
  #   
  #   def update
  #     @film = Film.find(params[:id])
  #     if @film.imdb_url.nil?
  #       @film.update_attributes(:imdb_url => params["film"]["imdb_url"])
  #     end
  #     redirect_to films_path
  #   end
  
end
