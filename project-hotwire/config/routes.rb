Rails.application.routes.draw do
  devise_for :users
  get 'pages/home'
  root 'pages#home', as: :home

  devise_scope :user do
    root 'projects#index'
    resources :projects do
      resources :votes
      resources :tasks
    end
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
