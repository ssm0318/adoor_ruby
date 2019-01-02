class Question < ApplicationRecord
    has_many   :answers
    has_many   :assignments
    has_many   :stars
    belongs_to :author, class_name: 'User'

    # after_create :create_notifications

    # private

    # def create_notifications
    #     User.find_each do |user|
    #         Notification.create(recipient: user, actor: User.find(1), target: self, action: "new question")
    #     end

    #     if !self.author.has_role? :admin
    #         Notification.create(recipient: self.author, actor: User.find(1), target: self, action: "custom question posted")
    #     end
    # end
end 
