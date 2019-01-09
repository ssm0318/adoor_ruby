class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        Like.create(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_likes_path(current_user.id)
    end

    def user_likes
        @user = User.find(params[:id])
        @likes = @user.likes
    end

    def destroy
        like = Like.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
        like.destroy_all

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_likes_path(current_user.id)
    end
end
