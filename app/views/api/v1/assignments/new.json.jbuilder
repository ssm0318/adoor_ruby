json.data do
  json.partial! 'api/v1/questions/question', question: @question
end
