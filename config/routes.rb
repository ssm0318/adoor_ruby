Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root '/'

  get '/questions' => 'questions#index', as: :questions
  get '/users/friends' => 'users#friends', as: :friends

  get '/users/profile/:id/edit' => 'users#edit', as: :edit_user_profile
  patch '/users/profile/:id/edit' => 'users#update', as: :update_user_profile
  get '/mypage' => 'users#mypage', as: :show_mypage

  devise_for :users
end
