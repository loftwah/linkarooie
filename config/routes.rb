Rails.application.routes.draw do
  if Rails.env.production?
    devise_for :users, skip: [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
      put 'users' => 'devise/registrations#update', as: 'user_registration'
    end
  else
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }
  end

  resources :links do
    member do
      get :track_click
    end
  end

  # Other routes
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'pages#home'
  resources :links, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :achievements, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  get '/:username', to: 'links#user_links', as: 'user_links'
end
