Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'questions#today'
  root 'answers#friend_feed'
  get 'intro' => 'questions#intro'

  post '/assignments/:assignee_id/:question_id' => 'assignments#create'
  delete '/assignments/:assignee_id/:question_id' => 'assignments#delete'

  get '/notifications/:id' => 'notifications#read'
  
  get '/feeds' => 'answers#general_feed'
  get '/questions/:id/friend' => 'answers#question_feed_friend'
  get'/questions/:id/general' => 'answers#question_feed_general'

  get '/questions/:id' => 'questions#question_feed'
  get '/today' => 'questions#today'
  # 이거 나중에 id 말고 content로 하는 게 더 보기 좋을 듯..! 
  get '/recover_password' => 'users#recover_password'
  post '/recover_password' => 'users#send_temporary_password'

  resources :answers, except: [:new, :edit]
  get '/answers/new/question/:id' => 'answers#new', as: :new_answer
  get '/answers/edit/question/:id' => 'answers#edit', as: :edit_answer

  resources :highlights
  resources :drawers
  resources :likes
  
  # user answers, highlights, drawers, likes
  get '/userpage/:id' => 'answers#user_answers', as: :user_answers
  #get '/userpage/:id/highlights' => 'highlights#user_highlights', as: :user_highlights
  get '/userpage/:id/drawers' => 'drawers#user_drawers', as: :user_drawers
  get '/userpage/:id/likes' => 'likes#user_likes', as: :user_likes

  # friend request
  post '/users/:id/add_friend' => 'users#add_friend', as: :add_friend
  post '/users/:id/friend_request' => 'users#friend_request', as: :friend_request

  # comment
  post '/answers/:id/comments/:recipient_id' => 'answers#create_comment', as: :new_comment
  post '/answers/comment/:id/reply' => 'answers#create_reply', as: :new_reply

  get '/questions' => 'questions#index', as: :questions
  get '/users/friends' => 'users#friends', as: :friends

  get '/users/profile/:id/edit' => 'users#edit', as: :edit_user_profile
  patch '/users/profile/:id/edit' => 'users#update', as: :update_user_profile
  get '/mypage' => 'users#mypage', as: :show_mypage

  get '/invitation' => 'questions#invitation', as: :invitation
  get '/invitation/link' => 'questions#link_generation', as: :link_generation
  get '/invitation/:id(/:question_id1(/:question_id2(/:question_id3)))' => 'users#accept_invitation', as: :accept_invitation
  # search
  get '/search/all' => 'search#all', as: :search_all
  get '/search/json' => 'search#json'
  get '/search/admin_question' => 'search#admin_question', as: :search_admin_question
  get '/search/custom_question' => 'search#custom_question', as: :search_custom_question
  get '/search/friend_answer' => 'search#friend_answer', as: :search_friend_answer
  get '/search/anonymous_answer' => 'search#anonymous_answer', as: :search_anonymous_answer
  get '/search/popular_tags' => 'search#popular_tags', as: :show_popular_tags
  get '/search/popular_search' => 'search#popular_search', as: :show_popular_search
  get '/search/user' => 'search#user', as: :search_user

  devise_for :users
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }

  # add question (admin only)
  get '/admin/import_all_questions' => 'questions#import_all', as: :import_all_questions
  get '/admin/import_new_questions' => 'questions#import_new', as: :import_new_questions
end
