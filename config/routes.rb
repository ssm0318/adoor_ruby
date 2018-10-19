Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'

  resources :answers

  resources :highlights
  resources :stars
  
  # user answers, highlights, stars
  get '/:id' => 'answers#user_answers', as: :user_answers
  get '/:id/highlights' => 'highlights#user_highlights', as: :user_highlights
  get '/:id/stars' => 'stars#user_stars', as: :user_stars

  # friend request
  post '/users/:id/add_friend' => 'users#add_friend', as: :add_friend
  post '/users/:id/friend_request' => 'users#friend_request', as: :friend_request

  # comment
  post 'answers/:id/comments' => 'answers#create_comment'
end