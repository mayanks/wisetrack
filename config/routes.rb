BlackSwan::Application.routes.draw do
  resources :transactions

  resources :accounts

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  match "/categories", :to => "category#index"
  match "/transactions/transfer", :to => "transactions#transfer", :via => :post
end
