class StarsController < ApplicationController
    def create
        #@star = Star.create()
    end

    def user_stars
        @user = User.find(params[:id])
        @stars = @user.stars
    end

    def destroy
        star = Star.find(params[:id])
        star.destroy

        # FIXME: current_user.id로 바꾸자
        redirect_to user_stars_path(1)
    end
end
