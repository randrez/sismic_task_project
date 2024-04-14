Rails.application.routes.draw do
  namespace :api do
    resources :features, only: [:index] do
      resources :comments, only: [:create_comment]
    end
  end
end
