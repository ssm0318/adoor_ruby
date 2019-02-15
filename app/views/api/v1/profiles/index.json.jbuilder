json.data do
  json.user do
    json.partial! 'api/v1/users/user', user: user
  end
  json.feeds do
    json.array! feeds do |feed|
        json.partial! 'api/v1/feeds/feed', feed: feed
    end
  end
end
  