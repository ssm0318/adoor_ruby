json.data do
  json.partial! 'api/v1/questions/question', question: @question
  json.partial! 'api/v1/users/user', user: @user
end
