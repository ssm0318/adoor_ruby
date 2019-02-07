json.data do
  json.partial! 'api/v1/questions/question', question: @question
  json.partial! 'api/v1/answers/answer', answer: @answer
end
