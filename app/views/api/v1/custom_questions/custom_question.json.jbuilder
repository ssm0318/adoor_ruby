json.data do
  json.custom_question do
    json.partial! 'api/v1/custom_questions/custom_question', custom_question: custom_question
  end
end
