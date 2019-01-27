class Entrance < ApplicationRecord
    belongs_to :channel
    belongs_to :target, polymorphic: true  # post, answer, custom_question
end
