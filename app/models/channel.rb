class Channel < ApplicationRecord
    belongs_to  :user
    has_and_belongs_to_many :friendships
    has_many    :friends, through: :friendships
    has_many    :entrances
    has_many    :posts, through: :entrances, source: :target, source_type: 'Post'
    has_many    :answers, through: :entrances, source: :target, source_type: 'Answer'
end
