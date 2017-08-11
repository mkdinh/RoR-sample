Rails.application.routes.draw do
  
  get '/signup', to: 'users#new'

  post '/signup'  , to: 'users#create'

  get '/help', to: 'static_pages#help'
	# route a get request for the URL /help to the help action in the staticpage controller 

  get '/about', to: 'static_pages#about' 

  get '/contact', to: 'static_pages#contact'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  resources :users
  #endowed all actions for RESTful resources
end
