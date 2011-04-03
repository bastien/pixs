class BookmarksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    @user = User.find_by_secret_id(params[:user_secret_id])
    @bookmarks = @user.bookmarks
    @bookmarked_films = current_user.present? ? current_user.films.to_a : []
  end
  
  def create
    @bookmark = current_user.bookmarks.create!(params[:bookmark])
    @selected = true
    render 'toggle'
  end
  
  def destroy
    @bookmark = current_user.bookmarks.where(:film_id => params[:id]).first
    @bookmark.destroy
    @selected = false
    render 'toggle'
  end
end
