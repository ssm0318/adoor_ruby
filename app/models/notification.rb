class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :target, polymorphic: true  
  # target can be answer, friendrequest, friendship, assignment, highlight or comment 
  # polymorphic type이기 때문에 target만 보내주면 target_id와 target_type이 알아서 생성됨.
  # https://guides.rubyonrails.org/association_basics.html#polymorphic-associations 참조

  # notification.unread로 확인하지 않은 노티들을 찾을 수 있음
  scope :unread, -> { where(read_at: nil) }
end
