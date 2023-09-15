Rails.application.routes.draw do
  resources :kanbans do
    member do
      patch :move
    end
    resources :kanban_columns do
      resources :cards
    end
  end
  get 'home/index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :settings, only: [:edit, :update]
  resources :links
  root to: "home#index"

  get '/:username', to: 'public_links#show', as: 'user_public_links'
end
