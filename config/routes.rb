Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end
  resources :surplus_lands do
    get :refine_search, on: :member
    get :search, on: :collection
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :rooms, only: [:show, :create] do
    resources :messages, only: [:create, :destroy]
  end
  resources :notifications, only: [:index]
end
