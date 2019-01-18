class CommentsController < ApplicationController
    def create
        if params[:secret].nil?
            secret = false
        else
            secret = params[:secret]
        end
        c = Comment.create(content: params[:content], author_id: current_user.id, target_type: params[:target_type], target_id: params[:target_id], anonymous: params[:anonymous], secret: secret)

        render json: {
            id: c.id,
            content: c.content,
            comment_id: c.id,
            created_at: c.created_at,
            like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
            like_changed_url: like_path(c.id, target_type: 'Comment'),
        }
        
    end

    def destroy
        c = Comment.find(params[:id])
        c.destroy
    end
end
