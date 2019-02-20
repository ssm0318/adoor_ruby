if feed.is_a? Answer
  json.type "answer"
  json.partial! 'api/v1/answers/answer', answer: feed
elsif feed.is_a? Post
  json.type "post"
  json.partial! 'api/v1/posts/post', post: feed
elsif feed.is_a? CustomQuestion
  json.type "custom_question"
  json.partial! 'api/v1/custom_questions/custom_question', custom_question: feed
end