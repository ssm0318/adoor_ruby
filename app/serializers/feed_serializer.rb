class FeedSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :question_id, :content, :tag_string, :created_at
end