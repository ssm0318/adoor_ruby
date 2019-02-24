class CommentShortSerializer < ActiveModel::Serializer
  attributes :id, :author, :content, :created_at

  def author
    ::UserShortSerializer.new(object.author).attributes
  end
end
