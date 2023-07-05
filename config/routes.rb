Rails.application.routes.draw do
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
  post '/refresh', to: 'sessions#refresh'
end
