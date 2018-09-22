Rails.application.routes.draw do
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root '/'

  get '/questions' => 'questions#index', as: :questions
  get '/user/friends' => 'users#friends', as: :friends

  get '/user/:id/edit' => 'users#edit', as: :edit_user_profile
  patch 'user/:id/edit' => 'users#update', as: :update_user_profile
  get '/mypage/:id' => 'users#mypage', as: :show_mypage
end
