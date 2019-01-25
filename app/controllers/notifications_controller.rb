class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def index
        @notifications = Notification.all
    end
    
    def read_all
        Notification.where(recipient_id: current_user.id).visible.unread.each do |n|
            n.read_at = DateTime.now()
            n.save(touch: false)
        end
    end

    def read
        noti = Notification.find(params[:id])

        if noti.recipient_id != current_user.id
            redirect_to root_path
        else
            if noti.read_at == nil
                noti.read_at = DateTime.now()
                noti.save(touch: false)  # updated_at을 update하지 않기 위해!!
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

            case target_type
            when 'Like'
                case origin_type
                when 'Post'
                    redirect_to post_path(origin_id)
                when 'Answer'
                    redirect_to answer_path(origin_id)
                when 'Comment'
                    case noti.origin.target_type
                    when 'Post'
                        redirect_to post_path(noti.origin.target_id)
                    when 'Answer'
                        redirect_to answer_path(noti.origin.target_id)
                    when 'Announcement'
                        redirect_to announcement_index_path
                    else
                    end
                when 'Reply'
                    case noti.origin.comment.target_type
                    when 'Post'
                        redirect_to post_path(noti.origin.comment.target_id)
                    when 'Answer'
                        redirect_to answer_path(noti.origin.comment.target_id)
                    when 'Announcement'
                        redirect_to announcement_index_path
                    else
                    end
                else
                end
            when 'Comment'
                case origin_type
                when 'Post'
                    redirect_to post_path(origin_id)
                when 'Answer'
                    redirect_to answer_path(origin_id)
                when 'Announcement'
                    redirect_to announcement_index_path
                else
                end
            when 'Reply'
                case noti.origin.target_type
                when 'Post'
                    redirect_to post_path(noti.origin.target.id)
                when 'Answer'
                    redirect_to answer_path(noti.origin.target.id)
                when 'Announcement'
                    redirect_to announcement_index_path
                else
                end
            when 'Drawer'
                case origin_type
                when 'Post'
                    redirect_to post_path(origin_id)
                when 'Answer'
                    redirect_to answer_path(origin_id)
                when 'Question'
                    redirect_to question_path(origin_id)
                else
                end
            when 'Assignment'
                redirect_to new_answer_path(origin_id)
            when 'Answer'
                redirect_to answer_path(origin_id)
            when 'Friendship'
                redirect_to profile_path(origin_id)
            # when 'Highlight'
            #     if origin_type == 'Post'
            #         redirect_to post_path(origin_id)
            #     elsif origin_type == 'Answer'
            #         redirect_to answer_path(origin_id)
            #     end
            when 'FriendRequest'
                redirect_to profile_path(origin_id)
            when 'Announcement'
                redirect_to announcement_index_path
            else
            end
        end
    end
end 