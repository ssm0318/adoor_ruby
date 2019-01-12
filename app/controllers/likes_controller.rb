class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        Like.create(user_id: current_user.id, target_id: params[:id], target_type: params[:target_type])

        render json: {

        }
    end 
    
    def destroy
        like = Like.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
        like.destroy_all

        render json: {
            
        }
    end
end
