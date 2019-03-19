class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author, :content, :secret, :created_at, :replies

  def replies
    object.replies.map do |reply|
      ::ReplySerializer.new(reply).attributes
    end
  end

  def author
    ::UserShortSerializer.new(object.author).attributes
  end
end
