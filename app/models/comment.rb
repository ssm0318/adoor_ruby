class Comment < ApplicationRecord
    belongs_to :answer
    belongs_to :author, class_name: 'User'
    # 글쓴이와 댓글 작성자가 댓글을 통해 지속적으로 대화를 이어나갈 수 있으므로 recipient 설정.
    belongs_to :recipient, class_name: 'User'

    after_create :create_notifications

    private

    # 댓글 달리면 recipient에게 보내지는 노티 생성.
    def create_notifications
        Notification.create(recipient: self.recipient, actor: self.author, target: self)
    end

end
