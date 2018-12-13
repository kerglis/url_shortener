Rails.application.routes.draw do
  devise_for :users

  resources :urls

  get '/*all', to: 'redirect#show', constraints: { all: /.*/ }
end
