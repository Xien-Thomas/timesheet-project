Rails.application.routes.draw do
  get 'timesheet/show'
  post 'login', to: 'session#create'
  get 'user/index', to: 'user#index'
  get 'user/index/:vendor', to: 'user#index'
  get 'user/:user_id', to: 'user#show'
  get 'entry/create'
  get 'entry/destroy'
  get 'entry/update'
  get 'entry/index'
  post 'user/create', to: 'user#create'
  put 'user/update/:user_id', to: 'user#update'
  delete 'user/destroy/:user_id', to: 'user#destroy'
  get 'user/show'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
