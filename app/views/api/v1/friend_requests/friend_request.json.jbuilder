json.data do
  json.friend_request do
    json.partial! 'api/v1/friend_requests/friend_request', friend_request: friend_request
  end
end
