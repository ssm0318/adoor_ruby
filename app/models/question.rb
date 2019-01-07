class Question < ApplicationRecord
    has_many   :answers, dependent: :destroy
    has_many   :assignments, dependent: :destroy
    has_many   :drawers, dependent: :destroy
    belongs_to :author, class_name: 'User'
    has_and_belongs_to_many :tags, dependent: :destroy

    scope :search_tag, -> (tag) { joins(:tags).where("tags.content LIKE ? ", "%#{tag}%").distinct }

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
