Rails.application.routes.draw do
  get 'likes/create'

  get 'likes/destroy'

  get 'sessions/new'

  root 'static_pages#home'
  get     '/help',    to: 'static_pages#help'
  get     '/about',   to: 'static_pages#about'
  get     '/contact', to: 'static_pages#contact'
  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers, :unread_messages, :likes
    end
  end
  resources :microposts, only: [:show, :create, :destroy] do
    member do
      get :likes
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :likes,               only: [:create, :destroy]
  resources :rooms,               only: [:create, :show]
  resources :messages,            only: [:create, :destroy]
end
