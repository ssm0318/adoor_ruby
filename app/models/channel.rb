class Channel < ApplicationRecord
    belongs_to  :user
    has_many    :listeners, class_name: 'Friendship'
end
