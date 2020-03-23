Rails.application.routes.draw do
  match '*path' => 'options_request#preflight', via: :options
  namespace :api, {format: 'json'} do
    resources :users, only: [:create, :show]
    resources :sessions, only: [:create, :destroy]
    resources :posts
    resources :favorites, only: [:index, :create, :destroy]
    get '/favorites/userIndex/:id', to: 'favorites#indexUsers'
    get '/favorites/count', to: 'favorites#count'
    resources :comments, only: [:create, :show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
