json.data do
  json.array! questions do |question|
    json.partial! 'api/v1/questions/question', question: question
  end
end
