class Drawer < ApplicationRecord
    belongs_to :user
    belongs_to :target, polymorphic: true  # post, answer, custom_question, question

    after_create :create_notifications
    after_destroy :destroy_notifications

    private 

    def create_notifications
        if !(self.target_type =='Question')
            if self.target.author != self.user
                noti_hash = {recipient: self.target.author, origin: self.target}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.target.author, actor: self.user, target: self, origin: self.target)
                else
                    n = Notification.where(noti_hash).first
                    n.target = self
                    n.save
                end
            end
        end
    end

    def destroy_notifications
        Notification.where(target: self).destroy_all
    end
end
