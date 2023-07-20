Rails.application.routes.draw do
  # get 'timesheet/show'
  # put 'timesheet/update/:id', to: 'timesheet#update'
  post 'login', to: 'session#create'
  post 'entry/create', to: 'entry#create'
  get 'entry/destroy'
  get 'entry/update'
  get 'entry/index'
  # get 'user/index', to: 'user#index'
  # get 'user/:user_id', to: 'user#show'
  # post 'user/create', to: 'user#create'
  # put 'user/update/:user_id', to: 'user#update'
  # delete 'user/destroy/:user_id', to: 'user#destroy'

  resources :user
  resources :timesheet
  resources :vendor, only: [:create]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
