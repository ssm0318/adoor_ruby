class Answer < ApplicationRecord
    belongs_to :author, class_name: 'User'
    belongs_to :question
    has_many   :highlights, dependent: :destroy
    has_many   :comments, dependent: :destroy, as: :target
    has_many   :likes, dependent: :destroy, as: :target
    has_many   :stars, dependent: :destroy
    has_and_belongs_to_many :tags, dependent: :destroy

    scope :anonymous, -> (id) { where.not(author: User.find(id).friends).where.not(author: User.find(id)) }

    scope :search_tag, -> (tag) { joins(:tags).where("tags.content LIKE ? ", "%#{tag}%").distinct }

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
