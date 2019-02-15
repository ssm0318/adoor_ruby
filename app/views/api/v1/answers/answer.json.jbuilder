json.data do
  json.answer do
    json.partial! 'api/v1/answers/answer', answer: answer
  end
  json.channel_names channel_names
end
