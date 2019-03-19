class ReplySerializer < ActiveModel::Serializer
  attributes :id, :author, :content, :secret, :target_author, :created_at

  def author
    ::UserShortSerializer.new(object.author).attributes
  end

  def target_author
    if object.target_author.nil?
      nil
    else
      ::UserShortSerializer.new(object.target_author).attributes
    end
  end
end
