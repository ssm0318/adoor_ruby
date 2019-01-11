class CommentsController < ApplicationController
    def create_for_answer
        id = params[:recipient_id]
        if id == '0'
            c = Comment.create(content: params[:content], author_id: current_user.id, target: Answer.find(params[:id]))

            render json: {
                content: c.content,
                comment_id: c.id,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        else
            c = Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], target: Answer.find(params[:id]))

            render json: {
                content: c.content,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        end
    end

    def create_for_post
        id = params[:recipient_id]
        if id == '0'
            c = Comment.create(content: params[:content], author_id: current_user.id, target: Answer.find(params[:id]))

            render json: {
                content: c.content,
                comment_id: c.id,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        else
            c = Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], target: Answer.find(params[:id]))

            render json: {
                content: c.content,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        end
    end
end
