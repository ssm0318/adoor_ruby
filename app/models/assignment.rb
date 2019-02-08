class Assignment < ApplicationRecord
    belongs_to :target, polymorphic: true
    belongs_to :assigner, :class_name => "User"
    belongs_to :assignee, :class_name => "User"

    after_create :create_notifications
    after_destroy :destroy_notifications

    private

    # assign하면 assign 받은 사람에게 보내지는 노티 생성.
    def create_notifications
        # 초대링크를 받은 사람이 보낸 사람과 친구가 아닌 경우 (자동으로 assigner이 1번 유저_admin으로 설정되어있음)에는 노티 생성 안함
        # 초대링크를 받은 사람이 보낸 사람과 친구인 경우
        if self.assigner_id != 1
            if self.target_type == "Question"
                Notification.create(recipient: self.assignee, actor: self.assigner, target: self, origin: self.target, action: "assignment")
            elsif self.target_type == "CustomQuestion"
                Notification.create(recipient: self.assignee, actor: self.assigner, target: self, origin: self.target, action: "custom-assignment")
            end
        end
    end

    # assignment가 취소되면 해당되는 노티도 지워짐
    def destroy_notifications
        Notification.where(recipient: self.assignee, actor: self.assigner, target: self).destroy_all
    end
end