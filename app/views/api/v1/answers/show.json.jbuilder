json.data do
  json.anonymous @anonymous
  json.partial! 'api/v1/answers/answer', answer: @answer
end
