json.data do
  json.anonymous_count anonymous_count
  json.friend_count friend_count
  json.array! users do |user|
    json.partial! 'api/v1/users/user', user: user
  end
end
