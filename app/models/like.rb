class Like < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :user

    after_create :create_notifications

    private 

    def create_notifications
        if self.target.author.friends.include? self.user
            Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'friend_like')
        else
            Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'anonymous_like')
        end
    end
end
