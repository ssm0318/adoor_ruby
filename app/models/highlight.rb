class Highlight < ApplicationRecord
    belongs_to :user
    belongs_to :answer

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.answer.author, actor: self.user, target: self)
    end
end
