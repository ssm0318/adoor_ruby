json.data do
  json.partial! 'api/v1/comments/comment', comment: @comment
  json.partial! 'api/v1/users/user', user: @user
end
