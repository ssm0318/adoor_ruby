class StarsController < ApplicationController
    before_action :authenticate_user!

    def create
        # TODO:
        # target이 answer일 때만 만들었음! question일 때까지 포괄하려면 코드를 추가해야 한다
        Star.create(user_id: current_user.id, target: Answer.find(params[:target_id]))

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_stars_path(current_user.id)
    end

    def user_stars
        @user = User.find(params[:id])
        @stars = @user.stars
    end

    def destroy
        # TODO:
        # 이것도 target이 answer일 때만 있음! question까지 포괄하고만 싶다
        star = Star.where(target_type: "Answer", target_id: params[:id], user_id: current_user.id)
        star.destroy_all

        # fallback_location은 그냥 임시
        redirect_back fallback_location: user_stars_path(current_user.id)
    end
end
