class Comment < ApplicationRecord
    belongs_to :target, polymorphic: true  # post, answer, custom_question
    belongs_to :author, class_name: 'User'
    has_many   :replies, dependent: :destroy
    has_many   :likes, dependent: :destroy, as: :target

    # 익명 댓글
    scope :anonymous, -> { where(anonymous: true) }
    scope :named, -> {where(anonymous: false)}
    # 내가 볼 수 있는 친구의 글의 실명 댓글 중 내가 볼 수 있는 것 찾아내기 (비밀 설정 안되어있는 것)
    scope :accessible, -> (id) { where(secret: false).or(Comment.where(author_id: id)).distinct } # 또는 글쓴이가 내 자신
    after_create :create_notifications
    after_destroy :destroy_notifications
 
    private 

    def create_notifications
        if self.target_type != 'Announcement'
            if self.author != self.target.author
                noti_hash = {recipient: self.target.author, origin: self.target}
                create_noti_hash = {recipient: self.target.author, actor: self.author, target: self, origin: self.target}
                # 익명 댓글인 경우
                if self.anonymous
                    noti_hash[:action] = 'anonymous_comment'
                    create_noti_hash[:action] = 'anonymous_comment'
                # 친구 댓글인 경우
                else
                    noti_hash[:action] = 'friend_comment'
                    create_noti_hash[:action] = 'friend_comment'
                end
                if !Notification.where(noti_hash).empty?
                    Notification.where(noti_hash).each do |n|
                        n.invisible = true
                        n.save(touch: false)
                    end
                end
                Notification.create(create_noti_hash)
            end
        end
    end

    def destroy_notifications
        if self.target_type != 'Announcement'
            if self.author != self.target.author
                noti_hash = {recipient: self.target.author, origin: self.target}
                # 익명 댓글인 경우
                if self.anonymous
                    noti_hash[:action] = 'anonymous_comment'
                # 친구 댓글인 경우
                else
                    noti_hash[:action] = 'friend_comment'
                end
                if Notification.where(noti_hash).size > 1
                    n = Notification.where(noti_hash)[-2]
                    n.invisible = false
                    if Notification.where(target: self).first.read_at != nil && n.read_at == nil
                        n.read_at =  Notification.where(target: self).first.read_at
                    end
                    n.save(touch: false)
                end
            end
        end
        Notification.where(target: self).destroy_all
    end
end
 