class Question < ApplicationRecord
    has_many :answers
    has_many :assignments
    has_many :stars

    after_create :create_notifications

    private

    def create_notifications
        User.find_each do |user|
            Notification.create(recipient: user, target: self)
        end
    end
end
