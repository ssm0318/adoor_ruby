class Assignment < ApplicationRecord
    belongs_to :question
    belongs_to :assigner, :class_name => "User"
    belongs_to :assignee, :class_name => "User"

    after_create :create_notifications

    private

    def create_notifications
        Notification.create(recipient: self.assginee, actor: self.assigner, target: self)
    end
end
