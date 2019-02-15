json.data do
  json.query query
  json.user_results do
    json.array! results do |result|
      json.partial! 'api/v1/users/user', user: result
    end
  end
end
      