class Star < ApplicationRecord
    belongs_to :user
    belongs_to :target, polymorphic: true
    # polymorphic type이기 때문에 target만 보내주면 target_id와 target_type이 알아서 생성됨.
    # https://guides.rubyonrails.org/association_basics.html#polymorphic-associations 참조
end
