class QuestionShortSerializer < ActiveModel::Serializer
  attributes :id, :content, :tags

  def tags
    if object.tag_string.nil?
      nil
    else
      object.tag_string.gsub("\r\n", '\n').split('\n')
    end
  end
end
