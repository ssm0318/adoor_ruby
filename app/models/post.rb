class Post < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many   :comments, dependent: :destroy, as: :target
    has_many   :likes, dependent: :destroy, as: :target
    has_many   :entrances, as: :target, dependent: :destroy
    has_many   :channels, through: :entrances
    has_many   :drawers, dependent: :destroy, as: :target
    has_and_belongs_to_many :tags, dependent: :destroy, as: :target

    scope :anonymous, -> (id) { where.not(author: User.find(id).friends).where.not(author: User.find(id)) }
    scope :named, -> (id) { where(author: User.find(id).friends).or(where(author:User.find(id))) }

    scope :search_tag, -> (tag) { joins(:tags).where("tags.content LIKE ? ", "%#{tag}%").distinct }
end
  