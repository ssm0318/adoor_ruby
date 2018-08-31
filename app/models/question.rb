class Question < ApplicationRecord
    has_many :answers
    has_many :assignments
    has_many :stars
end
