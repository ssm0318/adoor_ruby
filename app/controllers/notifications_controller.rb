class NotificationsController < ApplicationController
    before_action :authenticate_user!
    
    def read

        noti = Notification.find(params[:id])

        if noti.recipient_id != current_user.id
            redirect_to root_path()
        else
            if noti.read_at == nil
                noti.read_at = DateTime.now()
                noti.save(touch: false)  # updated_at을 update하지 않기 위해!!
            end
            
            origin_id = noti.origin_id
            origin_type = noti.origin_type
            target_type = noti.target_type
            if target_type == 'Friendship'
                redirect_to user_answers_path(origin_id)
            elsif target_type == 'Answer'
                redirect_to answer_path(origin_id)
            elsif target_type == 'Assignment'
                redirect_to new_answer_path(origin_id)
            elsif target_type == 'Highlight'
                #if origin_type == 'Post'
                    #redirect_to post_path(origin_id)
                #elsif origin_type == 'Answer'
                redirect_to answer_path(origin_id)
                #end
            elsif target_type == 'Drawer'
                #if origin_type == 'Post'
                    #redirect_to post_path(origin_id)
                #elsif origin_type == 'Answer'
                redirect_to answer_path(origin_id)
                #end
            elsif target_type == 'Comment'
                #if origin_type == 'Post'
                    #redirect_to post_path(origin_id)
                #elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                #end
            elsif target_type == 'FriendRequest'
                redirect_to user_answers_path(origin_id)
            elsif target_type == 'Reply'
                #if origin_type == 'Post'
                    #redirect_to post_path(origin_id)
                #elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                #end
            elsif target_type == 'Like'
                #if origin_type == 'Post'
                    #redirect_to post_path(origin_id)
                #elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                #end
            end
        end
    end
end