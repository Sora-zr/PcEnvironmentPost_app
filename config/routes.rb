Rails.application.routes.draw do
  root to: 'home#top'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  namespace :desk do
    resources :posts do
      resources :comments, only: %i[create destroy]
      get :likes, on: :collection
    end
    resources :likes, only: %i[create destroy]
  end

  namespace :item do
    resources :posts do
      resources :comments, only: %i[create destroy]
      get :likes, on: :collection
    end
    resources :likes, only: %i[create destroy]
  end

end
