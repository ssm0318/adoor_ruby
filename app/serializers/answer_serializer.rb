class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :author, :question, :content, :likes_count, :comments_count, :drawers_count,
    :comments_sample, :channels_count, :channels, :created_at

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

  def comments_sample
    object.comments.where(author: current_user.friends, secret: false).sample(3).map do |comment|
      ::CommentShortSerializer.new(comment).attributes
    end
  end

  def channels_count
    object.channels.length
  end

  def author
    ::UserShortSerializer.new(object.author).attributes
  end

  def channels
    arr = []
    object.channels.map do |channel|
      arr.push(channel.name)
    end
    arr
  end
end
