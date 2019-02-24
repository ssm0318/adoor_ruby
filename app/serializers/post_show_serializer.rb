class PostShowSerializer < ActiveModel::Serializer
  attributes :id, :author, :content, :likes_count, :comments_count,
    :drawers_count, :channels_count, :channels, :comments

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
    arr = []
    object.channels.map do |channel|
      arr.push(channel.name)
    end
    arr
  end

  def comments
    instance_options[:comments].map do |comment|
      ::CommentSerializer.new(comment).attributes
    end
  end
end
