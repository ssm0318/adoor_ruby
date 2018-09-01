class Friendship < ApplicationRecord
    belongs_to :user
    belongs_to :friend, :class_name => "User"

    after_create :create_notifications, :delete_request, :create_inverse

    private

    def create_notifications
        Notification.create(recipient: self.friend, actor: self.user, target: self)
    end

    # 역 친구 관계를 만들어서 상대방도 나를 friends로 검색할 수 있게 한다.
    def create_inverse
        friendship_hash = { user: self.friend, friend: self.user }
        if Friendship.where(friendship_hash).empty?
            Friendship.create(friendship_hash)
        end
    end

    def delete_request
        f = FriendRequest.where(requester: self.friend, requestee: self.user)
        f.destroy_all
    end
end
