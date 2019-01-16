class CommentsController < ApplicationController
    def create
        id = params[:recipient_id]
        if id == '0'
            c = Comment.create(content: params[:content], author_id: current_user.id, target_type: params[:target_type], target_id: params[:target_id])

            render json: {
                id: c.id,
                content: c.content,
                comment_id: c.id,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
                profile_img_url: current_user.image.url,
                profile_path: profile_path(current_user.id),
                username: current_user.username
            }
        else
            c = Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], target_type: params[:target_type], target_id: params[:target_id])

            render json: { 
                id: c.id,
                content: c.content,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
                profile_img_url: current_user.image.url,
                profile_path: profile_path(current_user.id),
                username: current_user.username
            }
        end
    end

    def destroy
        c = Comment.find(params[:id])
        c.destroy
    end
end
