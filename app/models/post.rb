class Post < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many   :comments, dependent: :destroy, as: :target
    has_many   :likes, dependent: :destroy, as: :target
end
