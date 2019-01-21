class Reply < ApplicationRecord
    belongs_to :comment
    belongs_to :author, class_name: 'User'
    has_many   :likes, dependent: :destroy, as: :target

    # 익명 대댓글
    scope :anonymous, -> {where(anonymous: true)}
    # 내가 볼 수 있는 친구의 글의 실명 대댓글 중 내가 볼 수 있는 것 찾아내기 (비밀 설정 안되어있는 것)
    # secret 설정이 된 대댓글을 볼 수 있는 사람은 글쓴이와 댓글쓴이
    scope :accessible, -> (id) {joins(:comment).where(Reply.arel_table[:secret].eq(false).or(Reply.arel_table[:author_id].eq(id).or(Comment.arel_table[:author_id].eq(id))))}
    # https://stackoverflow.com/questions/10871131/how-to-use-or-condition-in-activerecord-query
    
    after_create :create_notifications

    private

    def create_notifications
        origin = self.comment
        # 익명 대댓글인 경우
        if self.anonymous
            if self.author != self.comment.author
                # 댓글 주인에게 노티
                noti_hash = {recipient: self.comment.author, action: 'anonymous_to_comment', origin: origin}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.comment.author, actor: self.author, target: self, action: 'anonymous_to_comment', origin: origin)
                else
                    n = Notification.where(noti_hash).first
                    n.target = self
                    n.actor = self.author
                    n.save
                end
            end
            if self.author != self.comment.target.author && self.comment.target.author != self.comment.author   # && 뒤는 댓글과 글의 작성자가 같은 경우 노티가 두번 가는 거 방지하기 위해
                # 글 주인에게 노티
                noti_hash = {recipient: self.comment.target.author, action: 'anonymous_to_author', origin: origin}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.comment.target.author, actor: self.author, target: self, action: 'anonymous_to_author', origin: origin)
                else
                    Notification.where(noti_hash).first.target = self
                    Notification.where(noti_hash).first.actor = self.author
                end
            end
        # 친구 대댓글인 경우
        else
            if self.author != self.comment.author
                # 댓글 주인에게 노티
                noti_hash = {recipient: self.comment.author, action: 'friend_to_comment', origin: origin}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.comment.author, actor: self.author, target: self, action: 'friend_to_comment', origin: origin)
                else
                    Notification.where(noti_hash).first.target = self
                    Notification.where(noti_hash).first.actor = self.author
                end
            end
            if self.author != self.comment.target.author && self.comment.target.author != self.comment.author   # && 뒤는 댓글과 글의 작성자가 같은 경우 노티가 두번 가는 거 방지하기 위해
                # 글 주인에게 노티
                noti_hash = {recipient: self.comment.target.author, action: 'friend_to_author', origin: origin}
                if Notification.where(noti_hash).unread.empty?
                    Notification.create(recipient: self.comment.target.author, actor: self.author, target: self, action: 'friend_to_author', origin: origin)
                else
                    Notification.where(noti_hash).first.target = self
                    Notification.where(noti_hash).first.actor = self.author
                end
            end
        end
    end
end
