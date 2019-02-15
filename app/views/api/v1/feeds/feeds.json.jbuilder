json.data do
  json.array! feeds do |feed|
    json.partial! 'api/v1/feeds/feed', feed: feed
  end
end
