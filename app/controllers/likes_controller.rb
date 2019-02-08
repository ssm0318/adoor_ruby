class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        l = Like.find_or_create_by(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

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

        likes = Like.where(target_type: params[:target_type], target_id: params[:target_id])

        puts '==============='
        puts likes
        users = []
        friends_count = 0

        likes.each do |like|
            user = like.user
            if user.id == current_user.id || (current_user.friends.include? user)
                users.push({ image_url: user.image.url, profile_path: profile_path(user), username: user.username})
                friends_count += 1
            end
        end

        html_content = render_to_string :partial => 'likes/likes_info', 
            :locals => { :users => users, :friends_count => friends_count, :anonymous_count => likes.count()-friends_count }

        render json: {
            html_content: html_content,
        }
    end
end
