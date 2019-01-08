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
            elsif noti.target_type == 'Answer'
                redirect_to answer_path(noti.target_id)
            elsif noti.target_type == 'Assignment'
                redirect_to new_answer_path(Assignment.find(noti.target_id).question_id)
            elsif noti.target_type == 'Highlight'
                redirect_to answer_path(Highlight.find(noti.target_id).answer_id)
            elsif noti.target_type == 'Drawer'
                redirect_to answer_path(Drawer.find(noti.target_id).target_id)
            elsif noti.target_type == 'Comment'
                #if Comment.find(noti.target_id).target_type == 'Post'
                    #redirect_to post_path(Comment.find(noti.target_id).target_id)
                #else
                    redirect_to answer_path(Comment.find(noti.target_id).target_id)
                #end
            elsif noti.target_type == 'FriendRequest'
                redirect_to user_answers_path(noti.actor_id)
            elsif noti.target_type == 'Reply'
                #if Comment.find(Reply.find(noti.target_id).comment_id).target_type == 'Post'
                    #redirect_to post_path(Comment.find(Reply.find(noti.target_id).comment_id).target_id)
                #else
                    redirect_to answer_path(Comment.find(Reply.find(noti.target_id).comment_id).target_id)
                #end
            elsif noti.target_type == 'Like'
                #if Like.find(noti.target_id).target_type == 'Post'
                    #redirect_to post_path(Like.find(noti.target_id).target_id)
                #else
                redirect_to answer_path(Like.find(noti.target_id).target_id)
                #end
            end
        end
    end
end