class Comment < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :author, class_name: 'User'
    has_many   :replies, dependent: :destroy
    has_many   :likes, dependent: :destroy, as: :target

    # 익명 댓글
    scope :anonymous, -> { where(recipient_id: nil) }
    
    after_create :create_notifications
 
    private 

    def create_notifications
        # 익명 댓글인 경우
        if !self.recipient_id.present?
            if self.author != self.target.author
                noti_hash = {recipient: self.target.author, actor: self.author, action: 'anonymous_comment', origin: self.target}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.target.author, actor: self.author, target: self, action: 'anonymous_comment', origin: self.target)
                else
                    Notification.where(noti_hash).first.target = self
                end
            end
        # 친구 댓글인 경우
        else
            # 글쓴이가 다른사용자의 댓글에 대해 대댓글을 단 경우
            if self.author == self.target.author && self.recipient_id != self.target.author_id
                noti_hash = {recipient: User.find(self.recipient_id), actor: self.author, action: 'recomment', origin: self.target}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: User.find(self.recipient_id), actor: self.author, target: self, action: 'recomment', origin: self.target)
                # 안읽은 같은 노티가 이미 있는 경우, 시간만 update해준다
                else
                    Notification.where(noti_hash).first.target = self
                end
            # 다른사용자(친구)가 글쓴이의 답변에 댓글을 단 경우
            elsif self.author != self.target.author
                noti_hash = {recipient: self.target.author, actor: self.author, action: 'comment', origin: self.target}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.target.author, actor: self.author, target: self, action: 'comment', origin: self.target)
                # 안읽은 같은 노티가 이미 있는 경우, target만 update해준다 (그러면 updated_at도 update됨)
                else
                    Notification.where(noti_hash).first.target = self
                end
            end    
        end
    end
end
 