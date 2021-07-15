Rails.application.routes.draw do
  devise_for :users
  get "home/about" => "homes#about"
  root to: 'homes#top'
  resources :users, only: [:index, :show, :edit, :update] do
    # ——————————————— ここから ———————————————
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    # ——————————— ここまでネストさせる ———————————
  end

  resources :events, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :event_comments, only: [:create, :destroy]
  end

  resources :tasks, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :checks, only: [:update]
    resource :likes, only: [:create, :destroy]
    resources :task_comments, only: [:create, :destroy]
  end
  # 検索機能実装のためのルーティングを設定する
  get "search" => "searches#search"
  delete 'notifications/destroy_all' => 'notifications#destroy_all'
  resources :notifications, only: [:index, :destroy]
  resources :maps, only: [:index]
  get '/map_request', to: 'maps#map', as: 'map_request'
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
