json.data do
  json.like do
    json.partial! 'api/v1/likes/like', like: like
  end
end
