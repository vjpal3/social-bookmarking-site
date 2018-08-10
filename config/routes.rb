Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  resources :articles, except: [:destroy]

  resources :books, except: [:destroy] do
    get 'search', on: :collection
  end

  resources :articles_users, only: [:create, :destroy]
  resources :books_users, only: [:new, :create, :update, :destroy]
end
