Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :settings, only: [:edit, :update]
  resources :links
  resources :tasks do
    patch :move, on: :member
    get :all_tasks, on: :collection
  end
  root to: "home#index"

  get '/:username', to: 'public_links#show', as: 'user_public_links'
end
