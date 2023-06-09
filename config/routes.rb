Rails.application.routes.draw do
  get 'timesheet/show'
  post 'login', to: 'session#create'
  get 'entry/create'
  get 'entry/destroy'
  get 'entry/update'
  get 'entry/index'
  get 'user/create'
  get 'user/update'
  get 'user/destroy'
  get 'user/show'
  get '/users', to:  'user#index'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
