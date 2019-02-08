json.data do
  json.question do
    json.partial! 'api/v1/questions/question', question: question
  end
  json.user do
    json.partial! 'api/v1/users/user', user: user
  end
end
