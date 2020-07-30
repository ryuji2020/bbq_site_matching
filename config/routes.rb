Rails.application.routes.draw do
  devise_for :users
  root 'surplus_lands#index'
end
