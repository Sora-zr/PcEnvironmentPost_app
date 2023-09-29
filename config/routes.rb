Rails.application.routes.draw do
  root to: 'home#top'

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :desk do
    resources :posts do
      resources :comments, only: %i[create destroy]
    end
  end

  namespace :item do
    resources :posts do
      resources :comments, only: %i[create destroy]
      get :bookmarks, on: :collection
    end
    resources :bookmarks, only: %i[create destroy]
  end

end
