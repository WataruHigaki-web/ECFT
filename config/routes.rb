# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users/products#top'

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :admins do
    root 'orders#top'
    get 'questions/index2'
    get 'orders/stock'
    patch 'admins/:id', to: 'questions#update2'
    put 'admins/:id', to: 'questions#update2'
    resources :users, only: %i[index show edit update] do
      collection do
        get :search
      end
    end
    resources :products
    resources :orders, only: %i[index show update] do
      collection do
        get :search
      end
    end
    resources :product_kinds, only: %i[index create edit update destroy]
    resources :point_events, only: %i[index create edit update destroy]
    resources :discounts, only: %i[index create edit update destroy]
    resources :combos,       only: %i[index edit create update destroy]
    resources :combo_items,  only: %i[show index create update destroy]
    resources :admins,       only: %i[index show edit update]
    resources :questions,    only: %i[index show edit update create destroy update]
  end

  namespace :users do
    root 'users#top'
    get 'users/point'
    get 'users/confirm'
    get 'orders/confirm'
    post 'orders/save'
    post 'cart_items/delete2'
    get 'orders/thanks'
    delete 'cart_items/destroy_all'
    get 'cart_items/save'
    patch 'users/:id', to: 'users#withdrawal'
    put 'users/:id', to: 'users#withdrawal'
    resources :users,        only: %i[show edit update]
    resources :discounts, only: %i[index show]
    resources :products,     only: %i[index show] do
      resource :favorites, only: %i[create destroy]
      resource  :likes, only: %i[create destroy]
      resources :product_comments, only: %i[create destroy]
    end
    resources :orders do
      collection do
        get :search
      end
    end
    resources :cart_items,   only: %i[index update destroy create] do
      collection do
        get :search
      end
    end
    resources :pays,  only: %i[index new destroy create edit update]
    resources :combo_items,  only: [:index,:show]
    resources :questions,    only:[:index,:create,:destroy]
    resources :discounts, only: %i[index]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end