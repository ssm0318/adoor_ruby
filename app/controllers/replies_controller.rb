class RepliesController < ApplicationController
    before_action :set_reply, only: [:destroy]

    def create
        secret = params[:secret].nil? ? false : params[:secret]
        r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id], secret: secret, anonymous: params[:anonymous], target_author_id: params[:target_author_id])

        target_author = params[:target_author_id] ? User.find(params[:target_author_id]).username : nil
 
        render json: {
            id: r.id,
            content: r.content,
            created_at: r.created_at,
            like_url: likes_path(target_id: r.id, target_type: 'Reply'), 
            like_changed_url: like_path(r.id, target_type: 'Reply'),
            profile_img_url: current_user.image.url,
            profile_path: profile_path(current_user.slug),
            username: current_user.username,
        }
    end

    def destroy
        @reply.destroy

        render json: {

        }
    end

    private
        def set_reply
            @reply = Reply.find(params[:id])
        end
end
