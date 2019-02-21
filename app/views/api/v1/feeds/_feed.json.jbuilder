if feed.is_a? Answer
  json.type "answer"
  json.attributes do
    json.partial! 'api/v1/answers/answer', answer: feed
  end
elsif feed.is_a? Post
  json.type "post"
  json.attributes do
    json.partial! 'api/v1/posts/post', post: feed
  end
elsif feed.is_a? CustomQuestion
  json.type "custom_question"
  json.attributes do
    json.partial! 'api/v1/custom_questions/custom_question', custom_question: feed
  end
end
