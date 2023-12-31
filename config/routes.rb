Rails.application.routes.draw do
  root to: 'home#top'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    # ゲストユーザー機能
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'

    # 退会機能
    get 'users/check', to: 'users/registrations#check'
    patch 'users/withdraw', to: 'users/registrations#withdraw'
  end

  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    collection do
      get :bookmarks
      get :diagnose
    end
  end
  resources :likes, only: %i[create destroy]
  resources :bookmarks, only: %i[create destroy]
  resources :items, only: %i[new create destroy]
  resources :diagnoses
  resource :profile, only: %i[show update]
  post 'posts/upload_image', to: 'posts#upload_image'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
