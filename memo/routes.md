Rails.application.routes.draw do
  devise_for :users
  

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships,only: [:create,:destroy]
    # get :followings, on: :member
    # get :followers, on: :member
    #あるユーザーがフォローする人全員を表示するルーティング
    #あるユーザーをフォローしてくれている人全員を表示するルーティング(つまりフォロワー)
    #on: :menberと書く事で、ルーティングにidを持たせることができる
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
end
