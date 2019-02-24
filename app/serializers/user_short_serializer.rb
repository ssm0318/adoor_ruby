class UserShortSerializer < ActiveModel::Serializer
  attributes :id, :username, :url

  def url
    object.image.url
  end
end
