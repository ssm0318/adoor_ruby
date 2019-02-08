json.data do
  json.array! feeds do |feed|
    if feed.is_a? Answer
      json.answer do
        json.partial! 'api/v1/answers/answer', answer: answer
      end
    elsif feed.is_a? Post
      json.post do
        json.partial! 'api/v1/posts/post', post: post
      end
    end
  end
end
