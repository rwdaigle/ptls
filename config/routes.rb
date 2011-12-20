ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'sessions', :action => 'start'

  map.resources :users

  map.resource :session

  map.resources :reviews, :member => { :review => :put }, :collection => { :shift => :put }
  
  map.resources :learnings, :member => { :review => :put }
  
  map.resources :associations
  
  map.resources :units, :member => { :edit_question => :get, :edit_answer => :get } do |unit|
    unit.resources :learnings
  end

  map.resources :subjects, :member => { :learn => :get, :review => :get, :quiz => :get } do |subject|
    subject.resources :learnings, :collection => { :today => :get }
    subject.resources :reviews, :collection => { :missed => :get, :shift => :put }
  end
  
  # Niceities
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
end
