json.data do
  json.array! @feeds do |feed|
    if feed.is_a? Answer
      json.partial! 'api/v1/answers/answer', answer: answer
    elsif feed.is_a? Post
      json.partial! 'api/v1/posts/post', post: post
    end
  end
end
