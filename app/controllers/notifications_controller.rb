class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def index
        @notifications = Notification.all
    end
    
    def read
        noti = Notification.find(params[:id])

        if noti.recipient_id != current_user.id
            redirect_to root_path
        else
            if noti.read_at == nil
                noti.read_at = DateTime.now()
                noti.save(touch: false)  # updated_at을 update하지 않기 위해!!
                puts '=================================================='
                puts noti.errors.full_messages
                puts '=================================================='
            end

            origin_id = noti.origin_id
            origin_type = noti.origin_type
            target_type = noti.target_type 

            puts '====================================================='
            puts 'id: ' + params[:id]
            puts 'origin_id: ' + origin_id.to_s
            puts 'origin_type: ' + origin_type
            puts 'target_type: ' + target_type
            puts '====================================================='

            if target_type == 'Friendship'
                redirect_to profile_path(origin_id)
            elsif target_type == 'Answer'
                redirect_to answer_path(origin_id)
            elsif target_type == 'Assignment'
                redirect_to new_answer_path(origin_id)
            # elsif target_type == 'Highlight'
            #     if origin_type == 'Post'
            #         redirect_to post_path(origin_id)
            #     elsif origin_type == 'Answer'
            #         redirect_to answer_path(origin_id)
            #     end
            elsif target_type == 'Drawer'
                if origin_type == 'Post'
                    redirect_to post_path(origin_id)
                elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                elsif origin_type == 'Question'
                    redirect_to question_path(origin_id)
                end
            elsif target_type == 'Comment'
                if origin_type == 'Post'
                    redirect_to post_path(origin_id)
                elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                end
            elsif target_type == 'FriendRequest'
                redirect_to profile_path(origin_id)
            elsif target_type == 'Reply'
                if noti.origin.target_type == 'Post'
                    redirect_to post_path(noti.origin.target.id)
                elsif noti.origin.target_type == 'Answer'
                    redirect_to answer_path(noti.origin.target.id)
                end
            elsif target_type == 'Like'
                if origin_type == 'Post'
                    redirect_to post_path(origin_id)
                elsif origin_type == 'Answer'
                    redirect_to answer_path(origin_id)
                elsif origin_type == 'Comment'
                    redirect_to answer_path(noti.origin.target.id)
                elsif origin_type == 'Reply'
                    redirect_to answer_path(noti.origin.comment.target.id)
                end
            end
        end
    end
end