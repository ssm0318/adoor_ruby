class Comment < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :author, class_name: 'User'
    has_many   :replies, dependent: :destroy

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.target.author, actor: self.author, target: self)
    end
end
 