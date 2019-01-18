class Reply < ApplicationRecord
    belongs_to :comment
    belongs_to :author, class_name: 'User'
    has_many   :likes, dependent: :destroy, as: :target

    # 익명 대댓글
    scope :anonymous, -> {where(anonymous: true)}
    # 내가 볼 수 있는 친구의 글의 실명 댓글 중 내가 볼 수 있는 것 찾아내기 (비밀 설정 안되어있는 것)
    # secret 설정이 된 대댓글을 볼 수 있는 사람은 글쓴이와 댓글쓴이
    scope :accessible, -> (id) {where(secret: false).or(Reply.where(author_id: id)).or(Reply.includes(:comment).references(:comment).where(comment: {author_id: id}))}
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
