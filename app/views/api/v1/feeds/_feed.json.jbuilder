if feed.is_a? Answer
  json.answer do
    json.partial! 'api/v1/answers/answer', answer: feed
  end
elsif feed.is_a? Post
  json.post do
    json.partial! 'api/v1/posts/post', post: feed
  end
elsif feed.is_a? CustomQuestion
  json.custom_question do
    json.partial! 'api/v1/custom_questions/custom_question', custom_question: feed
  end
end