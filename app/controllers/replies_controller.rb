class RepliesController < ApplicationController
    before_action :set_reply, only: [:destroy]

    def create
        if params[:secret].nil?
            secret = false
        else
            secret = params[:secret]
        end
        r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id], secret: secret, anonymous: params[:anonymous])
        
        render json: {
            id: r.id,
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
