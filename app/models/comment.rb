class Comment < ApplicationRecord
    belongs_to :answer
    belongs_to :author, class_name: 'User'

    after_create :create_notifications

    private

    # 댓글 달리면 글쓴이에게 보내지는 노티 생성.
    def create_notifications
        Notification.create(recipient: self.answer.author, actor: self.author, target: self)
    end
end
