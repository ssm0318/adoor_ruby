Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  get '/feeds' => 'questions#general_feed'
  get '/questions/:id' => 'questions#question_feed'
  # 이거 나중에 id 말고 content로 하는 게 더 보기 좋을 듯..! 
  get '/recover_password' => 'users#recover_password'
  post '/recover_password' => 'users#send_temporary_password'
  resources :answers, except: [:index]
end
