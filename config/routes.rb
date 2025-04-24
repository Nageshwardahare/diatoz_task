# config/routes.rb
Rails.application.routes.draw do
  get "loan_adjustments/new"
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users
  root "loans#index"

  resources :users, only: [ :show ]
  resources :loans do
    member do
      patch :approve
      patch :reject
      patch :confirm
      patch :adjust
      patch :accept_adjustment
      patch :request_readjustment
      patch :reject_readjustment
      post  :repay
    end
    resources :loan_adjustments, only: [ :new, :create ]
  end
end
