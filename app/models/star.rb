class Star < ApplicationRecord
    # belongs_to :user
    # belongs_to :question
    # belongs_to :answer
    # belongs_to :tmi

    belongs_to :user
    belongs_to :target, polymorphic: true
end
