class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        l = Like.create(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

        render json: {

        }
    end 
    
    def destroy
        like = Like.where(user_id: current_user.id, target_type: params[:target_type], target_id: params[:id])
        like.destroy_all

        render json: {
            
        }
    end

    def likes_info
        target = Like.where(target_type: params[:target_type], target_id: params[:target_id])
        users = []

        target.likes.each do |like|
            const user = like.user
            users.push({image_url: user.image.url, profile_path: profile_path(user), username: user.name})
        end

        html_content = render_to_string :partial => 'likes/likes_info', :locals => { :users => users }

        render json: {
            html_content: html_content,
        }
    end
end
