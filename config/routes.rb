Rails.application.routes.draw do
  devise_for :users

  resources :urls

  get '/*all', to: 'redirect#index', constraints: { all: /.*/ }
end
