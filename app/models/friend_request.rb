class FriendRequest < ApplicationRecord
    belongs_to :requester, :class_name => "User"
    belongs_to :requestee, :class_name => "User"

    after_create :create_notifications

    private

    # 친추 보내면 친추 받은 사람에게 보내지는 노티 생성
    def create_notifications
        Notification.create(recipient: self.requestee, actor: self.requester, target: self)
    end
end
