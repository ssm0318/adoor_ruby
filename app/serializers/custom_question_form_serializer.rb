class CustomQuestionFormSerializer < ActiveModel::Serializer
  attributes :id, :content, :author, :channels, :repost_message

  def author
    ::UserShortSerializer.new(current_user).attributes
  end

  def channels
    if instance_options[:channels].nil?
      arr = []
      object.channels.map do |channel|
        arr.push(channel.name)
      end
      arr
    else
      instance_options[:channels]
    end
  end
end
