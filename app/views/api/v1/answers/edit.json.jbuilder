json.data do
  json.question do
    json.partial! 'api/v1/questions/question', question: question
  end
  json.answer do
    json.partial! 'api/v1/answers/answer', answer: answer
  end
end
