json.data do
  json.secret secret
  json.target_author target_author
  json.reply do
    json.partial! 'api/v1/replies/reply', reply: reply
  end
  json.user do
    json.partial! 'api/v1/users/user', user: user
  end
end
  