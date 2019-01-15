class Drawer < ApplicationRecord
    belongs_to :user
    belongs_to :target, polymorphic: true

    after_create :create_notifications

    private 

    def create_notifications
        if self.target.author != self.user
            noti_hash = {recipient: self.target.author, origin: self.target}
            if Notification.where(noti_hash).unread.empty?
                Notification.create(recipient: self.target.author, actor: self.user, target: self, origin: self.target)
            else
                Notification.where(noti_hash).first.target = self
            end
        end
    end
end
