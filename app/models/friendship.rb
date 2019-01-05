class Friendship < ApplicationRecord
    belongs_to :user
    belongs_to :friend, :class_name => "User"
    
    after_create :create_notifications, :delete_request, :create_inverse

    private

    def create_notifications
        Notification.create(recipient: self.friend, actor: self.user, target: self)
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
end
