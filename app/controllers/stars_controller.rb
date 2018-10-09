class StarsController < ApplicationController
    before_action :authenticate_user!

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
        
        redirect_to user_stars_path(current_user.id)
    end
end
