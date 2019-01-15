class DrawersController < ApplicationController
    before_action :authenticate_user!

    def create
        Drawer.create(user_id: current_user.id, target_id: params[:id], target_type: params[:target_type])

        # fallback_location은 그냥 임시
        # redirect_back fallback_location: user_drawers_path(current_user.id)
        render json: {

        }
    end

    def user_drawers
        @user = User.find(params[:id]) 
        @drawers = @user.drawers
    end

    def destroy
        drawer = Drawer.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
        drawer.destroy_all

        redirect_back fallback_location: profile_drawers_path(current_user.id)
    end
end
