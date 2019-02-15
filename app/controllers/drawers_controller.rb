class DrawersController < ApplicationController
    before_action :authenticate_user!

    def create
        Drawer.find_or_create_by(user_id: current_user.id, target_id: params[:id], target_type: params[:target_type])

        # fallback_location은 그냥 임시
        # redirect_back fallback_location: user_drawers_path(current_user.id)
        render json: {

        }
    end

    # def user_drawers
    #     @user = User.find(params[:id]) 
    #     @drawers = @user.drawers
    # end

    def destroy
        drawer = Drawer.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
        drawer.destroy_all

        #redirect_back fallback_location: profile_drawers_path(current_user.id)
        render json: {
            
        }
    end

    def drawers_info

        drawers = Drawer.where(target_type: params[:target_type], target_id: params[:target_id])
        users = []
        friends_count = 0

        drawers.each do |drawer|
            user = drawer.user
            if user.id == current_user.id || (current_user.friends.include? user)
                users.push({ image_url: user.image.url, profile_path: profile_path(user.slug), username: user.username})
                friends_count += 1
            end
        end

        html_content = render_to_string :partial => 'drawers/drawers_info', 
            :locals => { :users => users, :friends_count => friends_count, :anonymous_count => drawers.count()-friends_count }

        render json: {
            html_content: html_content,
        }
    end
end
