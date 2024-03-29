Rails.application.routes.draw do
  get 'register/info'

  get 'visitor/main'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Application
  get '/unread' => 'application#unread'
  get '/introduction' => 'application#intro', as: :introduction
  get '/require_confirmation' => 'application#require_confirmation', as: :require_confirmation

  # Answer
  resources :answers, except: [:new]
  get '/answers/:id/new' => 'answers#new', as: :new_answer

  # Post
  resources :posts, except: [:new]

  # CustomQuestion
  resources :custom_questions, only: [:show, :create, :destroy, :update, :edit]
  post '/custom_questions/:id/repost' => 'custom_questions#repost_create', as: :custom_question_repost
  get '/custom_questions/:id/repost' => 'custom_questions#repost_new', as: :custom_question_repost_new
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
  get '/assignments' => 'assignments#index', as: :assignments
  get '/assignments/:question_id' => 'assignments#new', as: :new_assignment
  post '/assignments/:assignee_id/:question_id' => 'assignments#create', as: :create_assignment # get?
  delete '/assignments/:assignee_id/:question_id' => 'assignments#destroy', as: :destroy_assignment
  post '/assignments/:assignee_id/custom_question/:custom_question_id' => 'assignments#create_custom', as: :create_custom_assignment # get?
  delete '/assignments/:assignee_id/custom_question/:custom_uestion_id' => 'assignments#destroy_custom', as: :destroy_custom_assignment
  get '/assignments/custom_question/:custom_question_id' => 'assignments#new_custom', as: :new_custom_assignment

  # Drawer
  resources :drawers, only: [:create, :destroy]
  get '/drawers/:target_type/:target_id' => 'drawers#drawers_info'

  # Highlight
  resources :highlights, only: [:create, :destroy]

  # Notification
  get '/notifications' => 'notifications#index' , as: :notifications
  get '/notifications/read_all' => 'notifications#read_all', as: :notification_read_all
  get '/notifications/:id' => 'notifications#read'

  # Profile
  get '/profiles/:id' => 'profiles#index', as: :profile
  get '/profiles/:id/drawers' => 'profiles#drawers', as: :profile_drawers

  # User
  get '/users/:id/edit' => 'users#edit', as: :edit_user_profile
  patch '/users/:id/edit' => 'users#update', as: :update_user_profile
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks', :confirmations => 'users/confirmations', :passwords => 'users/passwords', :sessions => 'users/sessions' }
  # 아래 코드는 이후에 멀티채널 구성에 맞추어 바뀌어야할수도.
  get '/users/friends' => 'users#friends', as: :friends
  put '/users/:id/image_upload' => 'users#image_upload', as: :image_upload
  # put '/users/:id/upload_image' => 'users#update', as: :upload_image
  post '/users/:id/add_friend' => 'users#add_friend', as: :add_friend # get?
  post '/users/:id/delete_friend' => 'users#delete_friend', as: :delete_friend
  # post '/users/:id/friend_request' => 'users#friend_request', as: :friend_request_send # get?
  
  # FriendRequest
  resources :friend_requests, only: [:destroy]
  get '/friend_requests' => 'friend_requests#index', as: :friend_requests
  post '/friend_requests/:id' => 'friend_requests#create', as: :friend_request_create
  put '/friend_requests/:id/deny' => 'friend_requests#deny', as: :friend_request_deny

  # Invitation
  get '/invitations' => 'invitations#index', as: :invitations
  get '/invitations/link' => 'invitations#link', as: :invitation_link
  get '/invitations/:id(/:question_id1(/:question_id2(/:question_id3)))' => 'invitations#accept', as: :invitation_accept

  # Search
  get '/search/all' => 'search#all', as: :search_all
  get '/search/admin_question' => 'search#admin_question', as: :search_admin_question
  get '/search/custom_question' => 'search#custom_question', as: :search_custom_question
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

  # User Stats
  get '/stats/daily' => 'stats#daily', as: :daily_stats
  get '/stats/monthly' => 'stats#monthly', as: :monthly_stats
  
  namespace 'api' do
    namespace 'v1', defaults: { format: :json } do
      
      # Sessions
      resource :sessions, only: [:create, :destroy, :show] # delete request가 실제로 user을 delete하는 것이 아니기 때문에 resources가 아니라 resource로 두는 것이 맞습니다. 고치지 말아주세요!
      resources :users, only: [:create] 

      # Answer
      resources :answers, except: [:new]
      get '/answers/:id/new' => 'answers#new', as: :new_answer
      get '/answers/:id/friend_comments' => 'answers#friend_comments'
      get '/answers/:id/general_comments' => 'answers#general_comments'
      get '/answers/:id/likes' => 'answers#likes'

      # Post
      resources :posts, except: [:new]
      get '/posts/:id/friend_comments' => 'posts#friend_comments'
      get '/posts/:id/general_comments' => 'posts#general_comments'
      get '/posts/:id/likes' => 'posts#likes'

      # CustomQuestion
      resources :custom_questions, only: [:show, :create, :destroy, :update, :edit]
      post '/custom_questions/:id/repost' => 'custom_questions#repost_create', as: :custom_question_repost_form
      get '/custom_questions/:id/repost' => 'custom_questions#repost_new', as: :custom_question_repost
      get '/custom_questions/:id/friend_comments' => 'custom_questions#friend_comments'
      get '/custom_questions/:id/general_comments' => 'custom_questions#general_comments'
      get '/custom_questions/:id/likes' => 'custom_questions#likes'

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
      get '/assignments' => 'assignments#index', as: :assignments

      get '/assignments/:question_id' => 'assignments#new', as: :new_assignment 
      post '/assignments/:assignee_id/:question_id' => 'assignments#create', as: :create_assignment # get?
      delete '/assignments/:assignee_id/:question_id' => 'assignments#destroy', as: :destroy_assignment
      
      post '/assignments/:assignee_id/custom_question/:custom_question_id' => 'assignments#create_custom', as: :create_custom_assignment # get?
      delete '/assignments/:assignee_id/custom_question/:custom_uestion_id' => 'assignments#destroy_custom', as: :destroy_custom_assignment
      get '/assignments/custom_question/:custom_question_id' => 'assignments#new_custom', as: :new_custom_assignment  

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

      # User
      get '/users/:id/edit' => 'users#edit', as: :edit_user_profile
      patch '/users/:id/edit' => 'users#update', as: :update_user_profile
      # devise_for :users, :controllers => {:confirmations => 'users/confirmations', omniauth_callbacks: 'user/omniauth_callbacks' }
      devise_for :users, :controllers => {:confirmations => 'users/confirmations' }
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
  end
end 
