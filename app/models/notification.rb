class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :target, polymorphic: true  
  belongs_to :origin, polymorphic: true
  # target can be answer, friendrequest, friendship, assignment, highlight or comment 
  # polymorphic type이기 때문에 target만 보내주면 target_id와 target_type이 알아서 생성됨.
  # https://guides.rubyonrails.org/association_basics.html#polymorphic-associations 참조

  # origin은 noti를 눌렀을 때 이동하는 페이지에 대응하는 모델 (노티의 발생지)
  # 예: 그 노티를 눌렀을 때 answer_path(:id)로 가야하면 그 id를 가진 answer이 origin임!
  # noti의 target이 answer, highlight, drawer, comment, like인 경우 answer이고
  # noti의 target이 friendship, friendrequest인 경우 noti의 actor인 user이고
  # noti의 target이 assignment인 경우 해당 assignment의 question이다
  ##### 예외: noti의 target이 reply인 경우 origin은 그 reply가 달린 댓글이다. ㅠㅠ (구현 상의 이유로)

  # notification.unread로 확인하지 않은 노티들을 찾을 수 있음
  scope :unread, -> { where(read_at: nil) }
  
end
