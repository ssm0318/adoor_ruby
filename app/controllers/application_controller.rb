class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :noties, :str_noti

  def noties
    if user_signed_in?
      @noties = Notification.where(recipient_id: current_user.id)
    end
  end

  # def str_noti (noti)
  #   if noti.target_type == 'Friendship'
  #     "#{User.find(noti.actor_id).email}님이 친구 신청을 보냈습니다."
  #   end
  #   if noti.target_type == 'Answer'
  #     "#{User.find(noti.actor_id).email}님이 회원님이 assign한 질문에 답장했습니다."
  #   end
  # end

  def index
  end
end

