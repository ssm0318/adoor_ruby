class Like < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :user

    after_create :create_notifications

    private 

    def create_notifications
        origin = nil
        if self.target_type == 'Comment'
            origin = self.target.target
        else
            origin = self.target
        end

        if self.target.author != self.user
            if self.target.author.friends.include? self.user
                Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'friend_like', origin: origin )
            else
                noti_hash = {recipient: self.target.author, action: 'anonymous_like', origin: origin }
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'anonymous_like', origin: origin)
                else
                    Notification.where(noti_hash).first.target = self
                end
            end
        end 
    end
end
