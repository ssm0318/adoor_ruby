json.data do
  json.anonymous anonymous
  json.post do
    json.partial! 'api/v1/posts/post', post: post
  end
end
