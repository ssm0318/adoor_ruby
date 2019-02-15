
json.data do
  json.questions questions do |question|
    json.content question
  end
  json.custom_questions custom_questions do |question|
    json.content question
  end
  json.waiting_questions waiting_questions do |question|
    json.content question
    assigner_ids = Assignment.where(assignee: current_user, target: question).pluck(:assigner_id).uniq
    json.assigners assigner_ids do |id|
      json.partial! 'api/v1/users/user', user: User.find(id)
    end
  end
  json.answered_questions answered_questions do |question|
    json.content question
    assigner_ids = Assignment.where(assignee: current_user, target: question).pluck(:assigner_id).uniq
    json.assigners assigner_ids do |id|
      json.partial! 'api/v1/users/user', user: User.find(id)
    end
  end
end
