class Drawer < ApplicationRecord
    belongs_to :user
    belongs_to :target, polymorphic: true

    after_create :create_notifications

    private 

    def create_notifications
        Notification.create(recipient: self.target.author, actor: self.user, target: self, origin: self.target)
    end
end
