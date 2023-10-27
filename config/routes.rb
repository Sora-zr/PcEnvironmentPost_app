Rails.application.routes.draw do
  root to: 'home#top'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :posts do
    resources :comments, only: %i[create destroy]
    get :bookmarks, on: :collection
  end
  resources :likes, only: %i[create destroy]
  resources :bookmarks, only: %i[create destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
