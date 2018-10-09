class StarsController < ApplicationController
    before_action :authenticate_user!

    def create
        Star.create(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_stars_path(current_user.id)
    end

    def user_stars
        @user = User.find(params[:id])
        @stars = @user.stars
    end

    def destroy
        star = Star.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
        star.destroy_all

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_stars_path(current_user.id)
    end
end
