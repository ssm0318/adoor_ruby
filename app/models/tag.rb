class Tag < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_and_belongs_to_many :questions, dependent: :destroy
    has_and_belongs_to_many :answers, dependent: :destroy
    has_and_belongs_to_many :posts, dependent: :destroy
    has_and_belongs_to_many :custom_questions, dependent: :destroy
    belongs_to :target, polymorphic: true

    scope :popular_tags, -> (num) { select('content, count(content) as freq').order('freq desc').group('content').take(num) }
end
