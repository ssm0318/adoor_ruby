class CustomQuestionShowSerializer < ActiveModel::Serializer
  attributes :id, :author, :content, :likes_count, :comments_count, :drawers_count,
    :channels_count, :channels, :repost_message, :ancestor_id, :tags, :comments, :created_at

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

  def tags
    arr = []
    object.tags.each do |tag|
      arr.push(tag.content)
    end
    arr
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
