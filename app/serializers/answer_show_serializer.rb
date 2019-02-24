class AnswerShowSerializer < ActiveModel::Serializer
  attributes :id, :author, :question, :content, :likes_count, :comments_count,
    :drawers_count, :channels_count, :channels, :comments

  def question
    ::QuestionShortSerializer.new(object.question).attributes
  end

  def likes_count
    object.likes.length
  end

  def comments_count
    object.comments.length
  end

  def drawers_count
    object.drawers.length
  end

  def channels_count
    object.channels.length
  end

  def author
    ::UserShortSerializer.new(object.author).attributes
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

  def comments
    if instance_options[:comments].nil? # for create
      nil
    else
      instance_options[:comments].map do |comment|
        ::CommentSerializer.new(comment).attributes
      end
    end
  end
end
