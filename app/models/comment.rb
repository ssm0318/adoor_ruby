class Comment < ApplicationRecord
    belongs_to :target, polymorphic: true  # post, answer, custom_question
    belongs_to :author, class_name: 'User'
    has_many   :replies, dependent: :destroy
    has_many   :likes, dependent: :destroy, as: :target

    # 익명 댓글
    scope :anonymous, -> { where(anonymous: true) }
    scope :named, -> {where(anonymous: false)}
    # 내가 볼 수 있는 친구의 글의 실명 댓글 중 내가 볼 수 있는 것 찾아내기 (비밀 설정 안되어있는 것)
    scope :accessible, -> (id) { where(secret: false).or(Comment.where(author_id: id)) } # 또는 글쓴이가 내 자신
    after_create :create_notifications
    after_destroy :destroy_notifications
 
    private 

    def create_notifications
        if self.target_type != 'Announcement'
            if self.author != self.target.author
                # 익명 댓글인 경우
                if self.anonymous
                    noti_hash = {recipient: self.target.author, action: 'anonymous_comment', origin: self.target}
                    if Notification.where(noti_hash).empty?
                        Notification.create(recipient: self.target.author, actor: self.author, target: self, action: 'anonymous_comment', origin: self.target)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.actor = self.author # 필요하지 않지만 일관성을 위해
                        n.read_at = nil
                        n.save
                    end
                # 친구 댓글인 경우
                else
                    noti_hash = {recipient: self.target.author, action: 'friend_comment', origin: self.target}
                    if Notification.where(noti_hash).empty?
                        Notification.create(recipient: self.target.author, actor: self.author, target: self, action: 'friend_comment', origin: self.target)
                    # 안읽은 같은 노티가 이미 있는 경우, target만 update해준다 (그러면 updated_at도 update됨)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.actor = self.author
                        n.read_at = nil
                        n.save
                    end
                end
            end
        end
    end

    def destroy_notifications
        Notification.where(target: self).destroy_all
    end
end
 