Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :settings, only: [:edit, :update]
  root to: "home#index"
end
