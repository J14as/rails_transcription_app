Rails.application.routes.draw do
  root to: 'transcriptions#new'
  get '/transcribe', to: 'transcriptions#new'
  resources :transcriptions, only: [:create, :show, :index]
  get '/summary/:id', to: 'transcriptions#summary'


  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
