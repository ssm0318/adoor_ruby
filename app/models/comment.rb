class Comment < ApplicationRecord
    belongs_to :answer
    belongs_to :author, class_name: 'User'

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.answer.author, actor: self.author, target: self)
    end
end
