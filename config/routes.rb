Rails.application.routes.draw do
  devise_for :users

  resources :urls, except: :show do
    get :statistics, on: :collection
  end

  get '/*all', to: 'redirect#index', constraints: { all: /.*/ }
end
