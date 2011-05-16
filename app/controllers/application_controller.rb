class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authenticate_user!
    redirect_to root_url, :alert => 'You need to login to perfom this action' and return false if current_user.nil?
    true
  end
end
