class Star < ApplicationRecord
    belongs_to :user
    belongs_to :question
    belongs_to :answer
    belongs_to :tmi

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.requestee, actor: self.requester, target: self)
    end
end
