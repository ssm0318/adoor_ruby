class Tag < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_and_belongs_to_many :questions, dependent: :destroy
    has_and_belongs_to_many :answers, dependent: :destroy
    belongs_to :target, polymorphic: true
    # Question.first.tags << t
end
