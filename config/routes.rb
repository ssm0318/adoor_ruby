Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#today'
  resources :answers

  get '/questions/:id' => 'questions#feed', as: :question_feed
  post 'assignments/:user_id/:question_id' => 'assignments#create'
  delete '/assignments/:id' => 'assignments#delete'
  
end
