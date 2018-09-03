class Highlight < ApplicationRecord
    belongs_to :user
    belongs_to :answer

    after_create :create_notifications

    private

    def create_notifications
        # 유저가 글을 하이라이트 했을 때 글 쓴 당사자에게 보내는 노티 만들어짐.
        # 다른 유저가 하이라이트한건 글쓴이 당사자에게 보이지 않게 만들기로 했으나, 익명으로라도 하이라이트가 보여야 글 쓰는 맛이 있지 않을까 싶어서 일단 둠. (현재 코멘트/스크랩 밖에 없음.)
        Notification.create(recipient: self.answer.author, actor: self.user, target: self)
    end
end
