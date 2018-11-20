class NotificationsController < ApplicationController
    before_action :authenticate_user!
    
    def read

        noti = Notification.find(params[:id])

        if noti.recipient_id != current_user.id
            redirect_to root_path()
        end

        if noti.read_at == nil
            noti.read_at = DateTime.now()
            noti.save()
        end
        
        if noti.target_type == 'Friendship'
            redirect_to "/userpage/#{noti.actor_id}"
        elsif noti.target_type == 'Assignment'
            redirect_to "/answers/new/question/#{noti.target_id}"
        else
            redirect_to "/answers/#{noti.target_id}"
        end

    end
end