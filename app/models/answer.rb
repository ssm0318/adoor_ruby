class Answer < ApplicationRecord
    belongs_to :author, class_name: 'User'
    belongs_to :question
    has_many   :highlights
    has_many   :comments
    has_many   :stars

    after_create :create_notifications

    private 

    # assign 당한 유저C가 해당 질문에 대해 답하면 그 질문에 대해 유저C를 assign한 모든 유저들에게 보내지는 노티 생성.
    # 노티 생성 후 해당 assignment 삭제
    # 시드 파일로도 확인 가능.
    def create_notifications
        assignment_hash = { question_id: self.question_id, assignee_id: self.author_id }
        Assignment.where(assignment_hash).find_each do |assignment|
            Notification.create(recipient: assignment.assigner, actor: self.author, target: self)
            assignment.destroy
        end
    end
end
