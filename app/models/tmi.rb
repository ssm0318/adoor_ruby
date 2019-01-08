class Tmi < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many :drawers, dependent: :destroy
end
