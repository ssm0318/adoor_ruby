class Like < ApplicationRecord
    belongs_to :target, polymorphic: true  # post, answer, custom_question, comment, reply
    belongs_to :user

    after_create :create_notifications
    after_destroy :destroy_notifications

    private 

    def create_notifications
        origin = self.target
        if self.target.author != self.user
            noti_hash = {recipient: self.target.author, origin: origin}
            create_noti_hash = {recipient: self.target.author, actor: self.user, target: self, origin: origin}
            # 친구의 좋아요
            if self.target.author.friends.include? self.user
                # 글에 좋아요
                case self.target_type
                when 'Post', 'Answer', 'CustomQuestion'
                    noti_hash[:action] = 'friend_like_article'
                    create_noti_hash[:action] = 'friend_like_article'
                when 'Comment'
                    noti_hash[:action] =  'friend_like_comment'
                    create_noti_hash[:action] = 'friend_like_comment'
                when 'Reply'
                    noti_hash[:action] =  'friend_like_reply'
                    create_noti_hash[:action] = 'friend_like_reply'
                else
                end
            # 익명의 좋아요
            else
                # 글에 좋아요
                case self.target_type
                when 'Post', 'Answer', 'CustomQuestion'
                    noti_hash[:action] = 'anonymous_like_article'
                    create_noti_hash[:action] = 'anonymous_like_article'
                when 'Comment'
                    noti_hash[:action] = 'anonymous_like_comment'
                    create_noti_hash[:action] = 'anonymous_like_comment'
                when 'Reply'
                    noti_hash[:action] = 'anonymous_like_reply'
                    create_noti_hash[:action] = 'anonymous_like_reply'
                else
                end
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
    
    def destroy_notifications
        origin = self.target
        if self.target.author != self.user
            noti_hash = {recipient: self.target.author, origin: origin}
            # 친구의 좋아요
            if self.target.author.friends.include? self.user
                case self.target_type
                when 'Post', 'Answer', 'CustomQuestion'
                    noti_hash[:action] = 'friend_like_article'
                when 'Comment'
                    noti_hash[:action] = 'friend_like_comment'
                when 'Reply'
                    noti_hash[:action] = 'friend_like_reply'
                else
                end
            # 익명의 좋아요
            else
                # 글에 좋아요
                case self.target_type
                when 'Post', 'Answer', 'CustomQuestion'
                    noti_hash[:action] = 'anonymous_like_article'
                when 'Comment'
                    noti_hash[:action] = 'anonymous_like_comment'
                when 'Reply'
                    noti_hash[:action] = 'anonymous_like_reply'
                else
                end 
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
        Notification.where(target: self).destroy_all
    end
end
