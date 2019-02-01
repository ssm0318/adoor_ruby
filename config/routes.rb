Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Application
  get '/unread' => 'application#unread'
  get '/introduction' => 'application#intro', as: :introduction

  # Answer
  resources :answers, except: [:new]
  get '/answers/:id/new' => 'answers#new', as: :new_answer

  # Post
  resources :posts, except: [:new]

  # CustomQuestion
  resources :custom_questions, only: [:show, :create, :destroy, :update, :edit]
  # get '/custom_questions/:id/repost' => 'custom_questions#repost', as: :custom_question_repost
  # get '/custom_questions/:id/message' => 'custom_questions#repost_create', as: :custom_question_repost
  post '/custom_questions/:id/repost' => 'custom_questions#repost_create', as: :custom_question_repost_form
  get '/custom_questions/:id/repost' => 'custom_questions#repost_new', as: :custom_question_repost
  # get '/custom_questions/:id/repost/edit' => 'custom_questions#repost_edit', as: :custom_question_repost_edit

  # Feed
  root 'feeds#friends'
  get '/feeds/general' => 'feeds#general', as: :general_feed

  # Question 
  get '/questions/today' => 'questions#today', as: :today_questions
  get '/questions/:id/friends' => 'questions#show_friends', as: :question_friends
  get '/questions/:id/general' => 'questions#show_general', as: :question_general
  get '/questions/import_all' => 'questions#import_all', as: :import_all_questions
  get '/questions/import_new' => 'questions#import_new', as: :import_new_questions
  resources :questions, only: [:index, :show]

  # Comment
  resources :comments, only: [:create, :destroy]

  # Reply
  resources :replies, only: [:create, :destroy]

  # Like
  resources :likes, only: [:create, :destroy]
  get '/likes/:target_type/:target_id' => 'likes#likes_info'

  # Assignment
  get '/assignments/:question_id' => 'assignments#new', as: :new_assignment
  post '/assignments/:assignee_id/:question_id' => 'assignments#create', as: :create_assignment # get?
  delete '/assignments/:assignee_id/:question_id' => 'assignments#destroy', as: :destroy_assignment

  # Drawer
  resources :drawers, only: [:create, :destroy]
  get '/drawers/:target_type/:target_id' => 'drawers#drawers_info'

  # Highlight
  resources :highlights, only: [:create, :destroy]

  # Notification
  get '/notifications/read_all' => 'notifications#read_all', as: :notification_read_all
  get '/notifications/:id' => 'notifications#read'
  get '/notifications/all/index' => 'notifications#index' , as: :notification_index 

  # Profile
  get '/profiles/:id' => 'profiles#index', as: :profile
  get '/profiles/:id/drawers' => 'profiles#drawers', as: :profile_drawers
  # get '/profiles/:id/highlights' => 'profiles#highlights', as: :profile_highlights

  # User
  get '/users/:id/edit' => 'users#edit', as: :edit_user_profile
  patch '/users/:id/edit' => 'users#update', as: :update_user_profile
  devise_for :users
  # 아래 코드는 이후에 멀티채널 구성에 맞추어 바뀌어야할수도.
  get '/users/friends' => 'users#friends', as: :friends
  put '/users/:id/image_upload' => 'users#image_upload', as: :image_upload
  # put '/users/:id/upload_image' => 'users#update', as: :upload_image
  post '/users/:id/add_friend' => 'users#add_friend', as: :add_friend # get?
  post '/users/:id/friend_request' => 'users#friend_request', as: :friend_request # get?
  

  # Invitation
  get '/invitations' => 'invitations#index', as: :invitation
  get '/invitations/link' => 'invitations#link', as: :invitation_link
  get '/invitations/:id(/:question_id1(/:question_id2(/:question_id3)))' => 'invitations#accept', as: :invitation_accept

  # Search
  get '/search/all' => 'search#all', as: :search_all
  get '/search/admin_question' => 'search#admin_question', as: :search_admin_question
  get '/search/custom_question' => 'search#custom_question', as: :search_custom_question
  # get '/search/friend_answer' => 'search#friend_answer', as: :search_friend_answer
  # get '/search/anonymous_answer' => 'search#anonymous_answer', as: :search_anonymous_answer
  get '/search/popular_tags' => 'search#popular_tags', as: :show_popular_tags
  get '/search/popular_search' => 'search#popular_search', as: :show_popular_search
  get '/search/user' => 'search#user', as: :search_user

  # Channel
  resources :channels, only: [:create, :update, :destroy]
  put '/channels/:id/edit_friendship' => 'channels#edit_friendship'

  # Announcement
  resources :announcements, only: [:create, :update, :destroy]
  get '/announcements' => 'announcements#index', as: :announcement_index
  get '/announcements/admin'  => 'announcements#admin_index', as: :announcement_admin_index
  get '/announcements/:id/publish' => 'announcements#publish', as: :announcement_publish
  get '/announcements/:id/noti' => 'announcements#noti', as: :announcement_noti
  
end
