class NotificationsController < ApplicationController
    before_action :authenticate_user!
    
    def read

        noti = Notification.find(params[:id])

        if noti.recipient_id != current_user.id
            redirect_to root_path()
        else
            if noti.read_at == nil
                noti.read_at = DateTime.now()
                noti.save()
            end
            
            if noti.target_type == 'Friendship'
                redirect_to user_answers_path(noti.actor_id)
            elsif noti.target_type == 'Assignment'
                redirect_to new_answer_path(Assignment.find(noti.target_id).question_id)
            elsif noti.target_type == 'Answer'
                redirect_to answer_path(noti.target_id)
            elsif noti.target_type == 'Comment'
                redirect_to answer_path(Comment.find(noti.target_id).target_id)
            elsif noti.target_type == 'Highlight'
                redirect_to answer_path(Highlight.find(noti.target_id).answer_id)
            elsif noti.target_type == 'Stars'
                redirect_to answer_path(Star.find(noti.target_id).target_id)
            elsif noti.target_type == 'FriendRequest'
                redirect_to user_answers_path(noti.actor_id)
            end
        end
    end
end