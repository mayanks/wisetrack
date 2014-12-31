BlackSwan::Application.routes.draw do
  match "/transactions/m", :to => "transactions#mobile", :via => :get
  resources :transactions
  match "/transactions/transfer", :to => "transactions#transfer", :via => :post
  resources :accounts do 
    resources :transactions
  end
  resources :category do
    resources :transactions
  end
  get "/reports/:date" => "reports#show"
  get "/reports/" => "reports#index"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#landing"
  devise_for :users
  resources :users
end
