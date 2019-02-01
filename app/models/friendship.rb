class Friendship < ApplicationRecord
    belongs_to :user
    belongs_to :friend, :class_name => "User"
    has_and_belongs_to_many :channels
    
    after_create :create_notifications, :delete_request, :create_inverse, :default_channel, :destroy_anonymous_notifications
    after_destroy :destroy_notifications, :destroy_assignments

    private

    def create_notifications
        Notification.create(recipient: self.friend, actor: self.user, target: self, origin: self.user, action: "friendship")
    end

    # 친구되면, 친구였던 시절 받은 노티들 사라짐. (내 글에 대한 것 빼고! 내 글에 달린 익명댓글은 계속 볼 수 있으므로)
    def destroy_anonymous_notifications
        comment_join = "INNER JOIN comments ON notifications.origin_id = comments.id AND notifications.origin_type = 'Comment'"
        post_join = "INNER JOIN posts ON comments.target_id = posts.id AND comments.target_type = 'Post'"
        answer_join = "INNER JOIN answers ON comments.target_id = answers.id AND comments.target_type = 'Answer'"
        custom_question_join = "INNER JOIN custom_questions ON comments.target_id = custom_questions.id AND comments.target_type = 'CustomQuestion'"
        reply_join = "INNER JOIN replies ON notifications.origin_id = replies.id AND notifications.origin_type = 'Reply'"

        Notification.where(recipient: self.friend, action: 'anonymous_to_comment', target_type: 'Reply').joins(comment_join).merge(Comment.joins(post_join).where(posts: {author_id: self.user_id})).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_to_comment', target_type: 'Reply').joins(comment_join).merge(Comment.joins(answer_join).where(answers: {author_id: self.user_id})).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_to_comment', target_type: 'Reply').joins(comment_join).merge(Comment.joins(custom_question_join).where(custom_questions: {author_id: self.user_id})).destroy_all

        Notification.where(recipient: self.friend, action: 'anonymous_like_comment', target_type: 'Like').joins(comment_join).merge(Comment.joins(post_join).where(posts: {author_id: self.user_id})).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_like_comment', target_type: 'Like').joins(comment_join).merge(Comment.joins(answer_join).where(answers: {author_id: self.user_id})).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_like_comment', target_type: 'Like').joins(comment_join).merge(Comment.joins(custom_question_join).where(custom_questions: {author_id: self.user_id})).destroy_all

        Notification.where(recipient: self.friend, action: 'anonymous_like_reply', target_type: 'Like').joins(reply_join).merge(Reply.joins(:comment).merge(Comment.joins(post_join).where(posts: {author_id: self.user_id}))).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_like_reply', target_type: 'Like').joins(reply_join).merge(Reply.joins(:comment).merge(Comment.joins(answer_join).where(answers: {author_id: self.user_id}))).destroy_all
        Notification.where(recipient: self.friend, action: 'anonymous_like_reply', target_type: 'Like').joins(reply_join).merge(Reply.joins(:comment).merge(Comment.joins(custom_question_join).where(custom_questions: {author_id: self.user_id}))).destroy_all
        #Notification.where(recipient: User.find(6), action: 'anonymous_like_reply', target_type: 'Like').joins("INNER JOIN replies ON notifications.origin_id = replies.id AND notifications.origin_type = 'Reply'").merge(Reply.joins(:comment).merge(Comment.joins("INNER JOIN posts ON comments.target_id = posts.id AND comments.target_type = 'Post'").where(posts: {author: User.find(3)}))).distinct
    end
    
    def destroy_notifications
        Notification.where(target: self).destroy_all
    end

    def destroy_assignments
        Assignment.where(assigner: self.friend, assignee: self.user).destroy_all
    end

    # 역 친구 관계를 만들어서 상대방도 나를 .friends 쿼리로 검색할 수 있게 한다.
    def create_inverse
        friendship_hash = { user: self.friend, friend: self.user }
        # create_inverse가 recursive하게 call되지 않도록 확인해준다.
        if Friendship.where(friendship_hash).empty?
            Friendship.create(friendship_hash)
        end
    end

    # 친추를 받아서 친구 모델이 생성되고 나면 해당 친추 모델을 삭제한다.
    def delete_request
        f = FriendRequest.where(requester: self.friend, requestee: self.user)
        f.destroy_all
    end

    def default_channel
        # 현재는 친구가 default로 삼촌 채널에 들어가도록 설정해놓음. (추후 변경 가능)
        Channel.where(user: user, name: "삼촌").first.friendships << self
    end
end
