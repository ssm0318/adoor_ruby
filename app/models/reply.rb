class Reply < ApplicationRecord
    belongs_to :comment
    belongs_to :author, class_name: 'User'

    after_create :create_notifications

    private

    def create_notifications
        origin = self.comment
        if self.author != self.comment.author
            # 댓글 주인에게 노티
            noti_hash = {recipient: self.comment.author, action: 'to_comment', origin: origin}
            if Notification.where(noti_hash).unread.empty?
                Notification.create(recipient: self.comment.author, actor: self.author, target: self, action: 'to_comment', origin: origin)
            else
                Notification.where(noti_hash).first.target = self
            end
        end
        if self.author != self.comment.target.author
            # 글 주인에게 노티
            noti_hash = {recipient: self.comment.target.author, action: 'to_author', origin: origin}
            if Notification.where(noti_hash).unread.empty?
                Notification.create(recipient: self.comment.target.author, actor: self.author, target: self, action: 'to_author', origin: origin)
            else
                Notification.where(noti_hash).first.target = self
            end
        end
    end
end
