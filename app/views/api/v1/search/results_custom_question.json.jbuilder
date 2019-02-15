json.data do
  json.query query
  json.custom_question_results do
    json.array! results do |result|
      json.partial! 'api/v1/custom_questions/custom_question', custom_question: result
    end
  end
end
  