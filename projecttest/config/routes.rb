Rails.application.routes.draw do
  resources :projects do
    resources :votes
  end
  root 'projects#index'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
