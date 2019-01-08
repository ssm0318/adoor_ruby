class Comment < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :author, class_name: 'User'
    has_many   :replies, dependent: :destroy

    after_create :create_notifications

    private

    def create_notifications
        # 익명 댓글인 경우
        if self.recipient.nil?
            if self.author != self.answer.author
                # 익명의 사람이 댓글을 단 경우
                Notification.create(recipient: self.answer.author, actor: self.author, target: self, action: 'anonymous_comment')
            end
        # 친구 댓글인 경우
        else
            # 글쓴이가 다른사용자의 댓글에 대해 대댓글을 단 경우
            if self.author == self.answer.author && self.recipient != self.answer.author
                Notification.create(recipient: self.recipient, actor: self.author, target: self, action: 'recomment')
            # 다른사용자가 글쓴이의 답변에 댓글을 단 경우
            elsif self.author != self.answer.author
                Notification.create(recipient: self.answer.author, actor: self.author, target: self, action: 'comment')
            end    
        end
    end
end
 