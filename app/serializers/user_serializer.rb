class UserSerializer < ActiveModel::Serializer  
  attributes :id, :email, :username, :date_of_birth, :created_at, :slug, :url

  def url
    object.image.url
  end
end
