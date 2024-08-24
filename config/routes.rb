Rails.application.routes.draw do
  get 'analytics/index'

  # Devise routes for user registration
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Routes for links with standard RESTful actions
  resources :links do
    member do
      get :track_click
    end
  end

  # Sidekiq monitoring
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  # Custom routes for user-specific views and analytics
  get '/:username/analytics', to: 'analytics#index', as: :user_analytics
  get '/:username(/:theme)', to: 'links#user_links', as: :user_links, constraints: { theme: /retro|win95|win98/ }

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root route
  root to: 'pages#home'

  # Additional resources
  resources :achievements, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end