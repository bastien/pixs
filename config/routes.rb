Films::Application.routes.draw do
  
  resources :lists, :shallow => true do
    resources :films, :only => [:index, :show]
    resource :calendar, :only => [:show], :controller => 'calendar'
  end
  
  resources :bookmarks, :only => [:create, :destroy]

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  match "/users/:user_secret_id" => "bookmarks#index"
  
  root :to => "lists#index"
end
