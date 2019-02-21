class Drawer < ApplicationRecord
    belongs_to :user
    belongs_to :target, polymorphic: true  # post, answer, custom_question, question

    after_create :create_notifications
    after_destroy :destroy_notifications

    private 

    def create_notifications
        if self.target_type !='Question'
            if self.target.author != self.user
                noti_hash = {recipient: self.target.author, origin: self.target, action: "drawer"}
                if !Notification.where(noti_hash).empty?
                    Notification.where(noti_hash).each do |n|
                        n.invisible = true
                        n.read_at = DateTime.now()
                        n.save(touch: false)
                    end
                end
                Notification.create(recipient: self.target.author, actor: self.user, target: self, origin: self.target, action: "drawer")
            end
        end
    end

    def destroy_notifications
        if self.target_type !='Question'
            if self.target.author != self.user
                noti_hash = {recipient: self.target.author, origin: self.target, action: "drawer"}
                if Notification.where(noti_hash).size > 1
                    n = Notification.where(noti_hash)[-2]
                    n.invisible = false
                    if (Notification.where(target: self).first.read_at != nil) && (n.read_at == nil)
                        n.read_at =  Notification.where(target: self).first.read_at
                    end
                    n.save(touch: false)
                end
            end
        end
        Notification.where(target: self).destroy_all
    end
end


