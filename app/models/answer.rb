class Answer < ApplicationRecord
    belongs_to :author, class_name: 'User'
    belongs_to :question
    has_many   :highlights
    has_many   :comments
    has_many   :stars

    after_create :create_notifications

    private 

    # send notifications to assigners
    def create_notifications
        assignment_hash = { question_id: self.question_id, assignee_id: self.author_id }
        Assignment.where(assignment_hash).find_each do |assignment|
            Notification.create(recipient: assignment.assigner, actor: self.author, target: self)
            assignment.destroy
        end
    end
end
