Rails.application.routes.draw do
  root to: 'home#index'
  resources :bookmarks, only: [:index]
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  namespace :api, format: 'json' do
    resources :bookmarks, only: [:index, :show, :create, :update, :destroy]
  end
end
