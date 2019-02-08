json.data do
  json.reposting @reposting
  json.partial! 'api/v1/custom_questions/custom_question', custom_question: @custom_question
end