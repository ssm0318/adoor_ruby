json.data do
  json.query query
  json.question_results do
    json.array! results do |result|
      json.partial! 'api/v1/questions/question', question: result
    end
  end
end
    