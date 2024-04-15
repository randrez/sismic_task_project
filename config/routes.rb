Rails.application.routes.draw do
  namespace :api do
    get 'features', to: 'features#index'
    post 'features/:id/comment', to: 'features#create_comment'
  end
end
