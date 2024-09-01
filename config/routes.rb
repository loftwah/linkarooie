Rails.application.routes.draw do
  get 'analytics/index'

  # Devise routes for user registration
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Sidekiq monitoring
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root route
  root to: 'pages#home'

  # Static routes should be defined before dynamic routes
  resources :achievements, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Routes for links with standard RESTful actions - move these above the dynamic route
  resources :links do
    member do
      get :track_click
    end
  end

  # Custom routes for user-specific views and analytics
  get '/:username/analytics', to: 'analytics#index', as: :user_analytics

  # Dynamic user-specific routes must be last to avoid conflicts with static routes
  get '/:username(/:theme)', to: 'links#user_links', as: :user_links, constraints: { theme: /retro|win95|win98/ }
end
