Rails.application.routes.draw do 
  post 'login', to: 'session#create'
  post '/send-message', to: 'user#send_message'

  resources :user
  resources :timesheet
  resources :vendor, only: [:create]
  resources :entry, only: [:destroy]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
