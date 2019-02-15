json.data do
  json.question do
    json.partial! 'api/v1/questions/question', question: question
  end
end
