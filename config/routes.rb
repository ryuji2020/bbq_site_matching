Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :surplus_lands do
    member do
      get :refine_search
    end
    resources :likes, only: [:create, :destroy]
  end
end
