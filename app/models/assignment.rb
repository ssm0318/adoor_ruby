class Assignment < ApplicationRecord
    belongs_to :question
    belongs_to :assigner, :class_name => "User"
    belongs_to :assignee, :class_name => "User"

    after_create :create_notifications

    private

    # assign하면 assign 받은 사람에게 보내지는 노티 생성.
    def create_notifications
        Notification.create(recipient: self.assignee, actor: self.assigner, target: self)
    end
end
