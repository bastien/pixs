Films::Application.routes.draw do
  
  resources :films, :only => [:index, :show]
  resources :bookmarks, :only => [:create, :destroy]
  resource :calendar, :only => [:show], :controller => 'calendar'
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  match "/users/:user_secret_id" => "bookmarks#index"
  
  root :to => "films#index"
end
