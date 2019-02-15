json.data do
  json.query query
  json.more_user more_user
  json.more_question more_question
  json.more_custom more_custom
  json.searchpath searchpath
  json.user_results do
    json.array! user_results do |user|
      json.partial! 'api/v1/users/user', user: user
    end
  end
  json.question_results do
    json.array! question_results do |question|
      json.partial! 'api/v1/questions/question', question: question
    end
  end
  json.custom_question_results do
    json.array! custom_question_results do |custom_question|
      json.partial! 'api/v1/custom_questions/custom_question', custom_question: custom_question
    end
  end
end
