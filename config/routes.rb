Rails.application.routes.draw do
  resources :pricings
  resources :services
  get "location", to: "moves#search_locations"
  mount ActionCable.server => "/cable"
  patch "completeds/:id" => "completeds#update"
  resources :notifications do
    resource :completed
  end
  resources :locations
  resources :moves

  resources :eirs
  resources :containers
  resources :permissions
  resources :roles

  root "pages#index"
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  get "users/new" => "users#new", as: :new_user
  get "users/:id" => "users#show", as: :user
  get "users" => "users#index", as: :users
  get "users/:id/edit" => "users#edit", as: :edit_user
  patch "users/:id" => "users#update"
  post "staff" => "users#create", as: :members
  delete "staff/:id" => "users#destroy", as: :delete_member
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # Defines the root path route ("/")
  # root "posts#index"
  # match "*path", to: "application#render_404", via: :all
end
