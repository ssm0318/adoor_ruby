json.data do
  json.partial! 'api/v1/answers/answer', answer: @answer
  json.channels @channel_names do |name|
    json.name name
  end
end
