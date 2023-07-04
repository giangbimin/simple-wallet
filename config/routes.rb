Rails.application.routes.draw do
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
end
