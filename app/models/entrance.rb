class Entrance < ApplicationRecord
    belongs_to :channel
    belongs_to :target, polymorphic: true  
end
