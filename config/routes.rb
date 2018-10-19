Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#today'
  resources :answers

  post 'assignments/:user_id/:question_id' => 'assignments#create'
  delete '/assignments/:id' => 'assignments#delete'
  
  get '/feeds' => 'questions#general_feed'
  get '/questions/:id' => 'questions#question_feed'
  # 이거 나중에 id 말고 content로 하는 게 더 보기 좋을 듯..! 
  get '/recover_password' => 'users#recover_password'
  post '/recover_password' => 'users#send_temporary_password'

  resources :answers

  resources :highlights
  resources :stars
  
  # user answers, highlights, stars
  get '/userpage/:id' => 'answers#user_answers', as: :user_answers
  get '/userpage/:id/highlights' => 'highlights#user_highlights', as: :user_highlights
  get '/userpage/:id/stars' => 'stars#user_stars', as: :user_stars

  # friend request
  post '/users/:id/add_friend' => 'users#add_friend', as: :add_friend
  post '/users/:id/friend_request' => 'users#friend_request', as: :friend_request

  # comment
  post 'answers/:id/comments' => 'answers#create_comment'
  # root '/'

  get '/questions' => 'questions#index', as: :questions
  get '/users/friends' => 'users#friends', as: :friends

  get '/users/profile/:id/edit' => 'users#edit', as: :edit_user_profile
  patch '/users/profile/:id/edit' => 'users#update', as: :update_user_profile
  get '/mypage' => 'users#mypage', as: :show_mypage

  devise_for :users
end
