json.data do
  json.question do
    json.partial! 'api/v1/questions/question', question: question
  end
  json.feeds do
    json.array! feeds do |feed|
      json.partial! 'api/v1/feeds/feed', feed: feed
    end
  end
end
    