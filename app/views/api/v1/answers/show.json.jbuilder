json.data do
  json.anonymous anonymous
  json.answer do
    json.partial! 'api/v1/answers/answer', answer: answer
  end
end
