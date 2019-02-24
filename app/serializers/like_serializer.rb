class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user

  def user
    ::UserShortSerializer.new(object.user).attributes
  end
end
