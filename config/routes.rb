Rails.application.routes.draw do
  # Static and more specific routes first
  get 'analytics/index'
  
  # Routes for users directory (static)
  resources :users, only: [:index]

  # Devise routes for user registration and authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Sidekiq monitoring
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Routes for waiting lists
  resources :waiting_lists, only: [:create]

  # Root route
  root to: 'pages#home'

  # Routes for achievements
  resources :achievements, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Routes for links with RESTful actions (no custom click tracking anymore)
  resources :links, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Custom routes for user-specific views and analytics
  get '/:username/analytics', to: 'analytics#index', as: :user_analytics

  # Dynamic user-specific routes must be last to avoid conflicts with static routes
  get '/:username(/:theme)', to: 'links#user_links', as: :user_links, 
      constraints: { 
        username: /(?!users|analytics|achievements|links|up|sidekiq)[a-zA-Z0-9_]+/, 
        theme: /retro|win95|win98/ 
      }
end
