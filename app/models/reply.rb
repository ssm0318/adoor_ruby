class Reply < ApplicationRecord
    belongs_to :comment
    belongs_to :author, class_name: 'User'

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.comment.author, actor: self.author, target: self)
    end
end
