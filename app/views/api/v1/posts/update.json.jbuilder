json.data do
  json.post do
    json.partial! 'api/v1/posts/post', post: post
  end
  json.array! channel_names do |name|
    json.name name
  end
end
