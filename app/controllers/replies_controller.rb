class RepliesController < ApplicationController
    def create
        r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id])
        answer_author_id = r.comment.target.author_id
        
        render json: {
            content: r.content,
            created_at: r.created_at,
            like_url: likes_path(target_id: r.id, target_type: 'Reply'), 
            like_changed_url: like_path(r.id, target_type: 'Reply'),
        }
    end

    def destroy
        @reply.destroy
    end

    private
        def set_reply
            @reply = Reply.find(params[:id])
        end
end
