Rails.application.routes.draw do
  get 'analytics/index'
  
  # Use the custom registrations controller in all environments
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :links do
    member do
      get :track_click
    end
  end

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  # Other routes
  get '/:username/analytics', to: 'analytics#index', as: :user_analytics
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'pages#home'
  resources :links, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :achievements, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  get '/:username', to: 'links#user_links', as: 'user_links'
end