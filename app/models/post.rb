class Post < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many   :comments, dependent: :destroy, as: :target
    has_many   :likes, dependent: :destroy, as: :target

    scope :anonymous, -> (id) { where.not(author: User.find(id).friends).where.not(author: User.find(id)) }
end
