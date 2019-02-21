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
            create = true
            case self.target_type
            when 'Post', 'Answer', 'CustomQuestion'
                if self.target.author.friends.include? self.user
                    noti_hash[:action] = 'friend_like_article'
                    create_noti_hash[:action] = 'friend_like_article'
                else
                    noti_hash[:action] = 'anonymous_like_article'
                    create_noti_hash[:action] = 'anonymous_like_article'
                end
            when 'Comment'
                if self.target.anonymous
                    # 공개범위에서 익명피드를 제거한 후 글쓴이가 익명댓글을 좋아한 경우 노티 안간다
                    if !self.target.target.is_a? Announcement 
                        if !self.target.target.channels.any?{|c| c.name == '익명피드'}
                            create = false
                        else
                            noti_hash[:action] = 'anonymous_like_comment'
                            create_noti_hash[:action] = 'anonymous_like_comment'
                        end
                    else
                        noti_hash[:action] = 'anonymous_like_comment'
                        create_noti_hash[:action] = 'anonymous_like_comment'
                    end
                else
                    # 더 이상 볼 수 없는 경우 노티 안간다
                    if (self.target.target.channels & self.target.author.belonging_channels).empty?
                        create = false
                    else
                        noti_hash[:action] =  'friend_like_comment'
                        create_noti_hash[:action] = 'friend_like_comment'
                    end
                end
            when 'Reply'
                if self.target.anonymous
                    if !self.target.comment.target.is_a? Announcement
                        if !self.target.comment.target.channels.any?{|c| c.name == '익명피드'}
                            create = false
                        else
                            noti_hash[:action] = 'anonymous_like_reply'
                            create_noti_hash[:action] = 'anonymous_like_reply'
                        end
                    else
                        noti_hash[:action] = 'anonymous_like_reply'
                        create_noti_hash[:action] = 'anonymous_like_reply'
                    end
                else
                    if (self.target.comment.target.channels & self.target.author.belonging_channels).empty?
                        create = false
                    else
                        noti_hash[:action] = 'friend_like_reply'
                        create_noti_hash[:action] = 'friend_like_reply'
                    end
                end
            else
            end
            if create
                if !Notification.where(noti_hash).empty?
                    Notification.where(noti_hash).each do |n|
                        n.invisible = true
                        n.read_at = DateTime.now()
                        n.save(touch: false)
                    end
                end
                Notification.create(create_noti_hash)
            end
        end 
    end
    
    def destroy_notifications
        origin = self.target
        if self.target.author != self.user
            noti_hash = {recipient: self.target.author, origin: origin}
            destroy = true
            case self.target_type
            when 'Post', 'Answer', 'CustomQuestion'
                if self.target.author.friends.include? self.user
                    noti_hash[:action] = 'friend_like_article'
                else
                    noti_hash[:action] = 'anonymous_like_reply'
                end
            when 'Comment'
                if self.target.anonymous
                    noti_hash[:action] = 'anonymous_like_comment'
                else
                    if (self.target.target.channels & self.target.author.belonging_channels).empty?
                        destroy = false
                    else
                        noti_hash[:action] =  'friend_like_comment'
                    end
                end
            when 'Reply'
                if self.target.anonymous
                    noti_hash[:action] = 'anonymous_like_reply'
                else
                    if (self.target.comment.target.channels & self.target.author.belonging_channels).empty?
                        destroy = false
                    else
                        noti_hash[:action] = 'friend_like_reply'
                    end
                end
            else
            end
            if destroy
                if Notification.where(noti_hash).size > 1
                    n = Notification.where(noti_hash)[-2]
                    n.invisible = false
                    if (Notification.where(target: self).first.read_at != nil) && (n.read_at == nil)
                        n.read_at = Notification.where(target: self).first.read_at
                    end
                    n.save(touch: false)
                end
                Notification.where(target: self).destroy_all
            end
        end
    end
end
