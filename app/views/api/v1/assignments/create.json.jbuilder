json.data do
  json.question do
    json.partial! 'api/v1/questions/question', question: question
  end
  json.assigned_user do
    json.partial! 'api/v1/users/user', user: assigned_user
  end
end
