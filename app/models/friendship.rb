class Friendship < ApplicationRecord
    belongs_to :user
    belongs_to :friend, :class_name => "User"

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.friend, actor: self.user, target: self)
    end
end
