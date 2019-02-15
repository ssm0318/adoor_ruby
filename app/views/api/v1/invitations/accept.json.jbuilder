json.data do
  json.user do
    json.partial! 'api/v1/users/user', user: user
  end
  json.array! assigned_questions do |question|
    json.partial! 'api/v1/questions/question', question: question
  end
end
