class FriendRequest < ApplicationRecord
    belongs_to :requester, :class_name => "User"
    belongs_to :requestee, :class_name => "User"

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.requestee, actor: self.requester, target: self)
    end
end
