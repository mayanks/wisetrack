BlackSwan::Application.routes.draw do
  resources :transactions
  resources :accounts do 
    resources :transactions
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#landing"
  devise_for :users
  resources :users
  match "/categories", :to => "category#index"
  match "/transactions/transfer", :to => "transactions#transfer", :via => :post
end
