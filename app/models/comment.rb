class Comment < ApplicationRecord
    belongs_to :answer
    belongs_to :author, class_name: 'User'
    # recipient는 해당 글에 대해 어떤 유저와 대화가 진행 중인지를 나타냄, 즉 글쓴이가 아닌 대화참여자
    # 예: 댓글의 author과 recipient가 같을 수 있음.
    belongs_to :recipient, class_name: 'User'

    after_create :create_notifications

    private

    # 댓글 달리면 recipient에게 보내지는 노티 생성.
    def create_notifications
        Notification.create(recipient: self.recipient, actor: self.author, target: self)
    end

end
