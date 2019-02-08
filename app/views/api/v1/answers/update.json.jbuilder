json.data do
  json.answer do
    json.partial! 'api/v1/answers/answer', answer: answer
  end
  json.array! channel_names do |name|
    json.name name
  end
end
