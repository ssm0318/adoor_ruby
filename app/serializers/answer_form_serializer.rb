class AnswerFormSerializer < ActiveModel::Serializer
  attributes :id, :content, :author, :question, :channels

  def author
    ::UserShortSerializer.new(current_user).attributes
  end

  def question
    ::QuestionShortSerializer.new(instance_options[:question]).attributes
  end

  def channels
    if instance_options[:channels].nil?
      arr = []
      object.channels.map do |channel|
        arr.push(channel.name)
      end
      arr
    else
      instance_options[:channels]
    end
  end
end
