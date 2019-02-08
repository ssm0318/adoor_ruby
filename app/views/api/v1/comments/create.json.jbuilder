json.data do
  json.comment do
    json.partial! 'api/v1/comments/comment', comment: comment
  end
  json.user do
    json.partial! 'api/v1/users/user', user: user
  end
end
