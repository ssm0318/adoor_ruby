class Api::V1::DrawersController < ApplicationController
  # before_action :authenticate_user

  def create
    @drawer = Drawer.create(user_id: current_user.id, target_id: params[:id], target_type: params[:target_type])

    render :create
  end

  def user_drawers
    @user = User.find(params[:id])
    @drawers = @user.drawers

    render :user_drawers
  end

  def destroy
    drawer = Drawer.where(target_type: params[:target_type], target_id: params[:id], user_id: current_user.id)
    
    if drawer.destroy_all
      render json: { status: 'SUCCESS', message: 'Deleted drawer' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'drawer not deleted', data: drawer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def drawers_info
    drawers = Drawer.where(target_type: params[:target_type], target_id: params[:target_id])
    @users = []
    @friends_count = 0

    drawers.each do |drawer|
      user = drawer.user
      if user.id == current_user.id || (current_user.friends.include? user)
        @users.push(image_url: user.image.url, profile_path: profile_path(user), username: user.username)
        @friends_count += 1
      end
    end

    @anonymous_count = drawers.count - friends_count

    render :drawers_info
  end

  # private

  # def authenticate_user
  #   user_token = request.headers['X-USER-TOKEN']
  #   if user_token
  #     @user = User.find_by_token(user_token)
  #     #Unauthorize if a user object is not returned
  #     if @user.nil?
  #       return unauthorize
  #     end
  #   else
  #     return unauthorize
  #   end
  # end

  # def unauthorize
  #   head status: :unauthorized
  #   return false
  # end
end
