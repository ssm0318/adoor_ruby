class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :target, polymorphic: true   
  # polymorphic type이기 때문에 target만 보내주면 target_id와 target_type이 알아서 생성됨.
  # https://guides.rubyonrails.org/association_basics.html#polymorphic-associations 참조

  scope :unread, -> { where(read_at: nil) }
end
