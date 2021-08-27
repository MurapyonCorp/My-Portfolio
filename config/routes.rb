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
    resources :favoriters, only: [:index]
    resources :event_comments, only: [:create, :destroy]
    resources :maps, only: [:index]
  end

  resources :tasks, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :checks, only: [:update]
    resource :likes, only: [:create, :destroy]
    resources :likers, only: [:index]
    resources :task_comments, only: [:create, :destroy]
  end
  # 検索機能実装のためのルーティングを設定する
  get "search" => "searches#search"
  resources :notifications, only: [:index, :destroy] do
    collection do
      delete 'destroy_all'
    end
  end
  get '/map_request', to: 'maps#map', as: 'map_request'
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :show, :index]
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
