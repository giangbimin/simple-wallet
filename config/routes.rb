Rails.application.routes.draw do
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
  post '/refresh', to: 'sessions#refresh'

  namespace :api do
    namespace :v1 do
      resources :personal_accounts, only: [:create]
      resources :stock_accounts, only: [:create]
      resources :team_accounts, only: [:create]
      resources :transactions, only: [:show]
      resources :wallets, only: [:show] do
        member do
          resources :transactions, only: [:create]
        end
      end
    end
  end
end
