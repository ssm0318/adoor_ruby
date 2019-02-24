class AnswerNewSerializer < ActiveModel::Serializer
  attributes :id, :content, :author, :question

  def author
    ::UserShortSerializer.new(current_user).attributes
  end

  def question
    ::QuestionShortSerializer.new(instance_options[:question]).attributes
  end
end
