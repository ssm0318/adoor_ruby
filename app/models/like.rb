class Like < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :user

    after_create :create_notifications

    private 

    def create_notifications
        Notification.create(recipient: self.target.author, actor: self.user, target: self)
    end
end
