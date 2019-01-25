class Like < ApplicationRecord
    belongs_to :target, polymorphic: true  # post, answer, custom_question, comment, reply
    belongs_to :user

    after_create :create_notifications
    after_destroy :destroy_notifications

    private 

    def create_notifications
        origin = self.target

        if self.target.author != self.user
            # 친구의 좋아요
            if self.target.author.friends.include? self.user
                # 글에 좋아요
                if self.target_type == 'Post' || self.target_type == 'Answer'
                    noti_hash = {recipient: self.target.author, action: 'friend_like_article', origin: origin}
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'friend_like_article', origin: origin )
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.save
                    end
                # 댓글에 좋아요
                elsif self.target_type == 'Comment'
                    noti_hash = {recipient: self.target.author, action: 'friend_like_comment', origin: origin}
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'friend_like_comment', origin: origin )
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.save
                    end
                # 대댓글에 좋아요
                elsif self.target_type == 'Reply'
                    noti_hash = {recipient: self.target.author, action: 'friend_like_reply', origin: origin }
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'friend_like_reply', origin: origin)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.save
                    end
                end
            # 익명의 좋아요
            else
                # 글에 좋아요
                if self.target_type == 'Post' || self.target_type == 'Answer'
                    noti_hash = {recipient: self.target.author, action: 'anonymous_like_article', origin: origin }
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'anonymous_like_article', origin: origin)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.save
                    end
                elsif self.target_type == 'Comment'
                    noti_hash = {recipient: self.target.author, action: 'anonymous_like_comment', origin: origin }
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'anonymous_like_comment', origin: origin)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
                        n.save
                    end
                elsif self.target_type == 'Reply'
                    noti_hash = {recipient: self.target.author, action: 'anonymous_like_reply', origin: origin }
                    if Notification.where(noti_hash).unread.empty?
                        Notification.create(recipient: self.target.author, actor: self.user, target: self, action: 'anonymous_like_reply', origin: origin)
                    else
                        n = Notification.where(noti_hash).first
                        n.target = self
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
