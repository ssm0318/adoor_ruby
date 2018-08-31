class Answer < ApplicationRecord
    belongs_to :author, class_name: 'User'
    belongs_to :question
    has_many   :highlights
    has_many   :comments
    # has_one    :notification
    has_many   :stars

    # 답한 친구가 있을 때마다 노티를 보낸다.
    # after_create :create_notifications

    # private

    # def create_notifications
    #     friends = self.author.friends + self.author.inverse_friends
    #     friends.each do |friend|
    #         Notification.create(recipient: friend, actor: self.author, target: self)
    #     end
    # end
end
