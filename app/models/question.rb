class Question < ApplicationRecord
    has_many   :answers, dependent: :destroy
    has_many   :assignments, dependent: :destroy
    has_many   :drawers, dependent: :destroy, as: :target
    has_and_belongs_to_many :tags, dependent: :destroy, as: :target

    scope :search_tag, -> (tag) { joins(:tags).where("tags.content LIKE ? ", "%#{tag}%").distinct }
    scope :popular_questions, -> { joins(:answers).group("answers.question_id").order("count(answers.question_id) desc").take(7) }

    # after_create :create_notifications

    # private

    # def create_notifications
    #     User.find_each do |user|
    #         Notification.create(recipient: user, actor: User.find(1), target: self, action: "new question")
    #     end

    #     if !self.author.has_role? :admin
    #         Notification.create(recipient: self.author, actor: User.find(1), target: self, action: "custom question posted")
    #     end
    # end
end 
