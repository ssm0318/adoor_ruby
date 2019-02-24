class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :content

  belongs_to :answer
  belongs_to :post
  belongs_to :custom_question
end
