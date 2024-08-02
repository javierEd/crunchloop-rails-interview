Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    resources :todo_lists, only: %i[index], path: :todolists do
      resources :todo_items, path: :todos, only: %i[index create update destroy] do
        member do
          patch :complete
        end
      end
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
