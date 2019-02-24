class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = Like.create(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

    # render :create, locals: { like: like }
  end

  def destroy
    like = Like.where(user_id: current_user.id, target_type: params[:target_type], target_id: params[:id])
    
    if like.destroy_all
      render json: { status: 'SUCCESS', message: 'Deleted like' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'like not deleted', data: like.errors.full_messages }, status: :unprocessable_entity
    end
  end 

  def likes_info
    likes = Like.where(target_type: params[:target_type], target_id: params[:target_id])
    @users = []
    @friends_count = 0

    likes.each do |like|
      user = like.user
      if user.id == current_user.id || (current_user.friends.include? user)
        @users.push(image_url: user.image.url, profile_path: profile_path(user), username: user.username)
        @friends_count += 1
      end
    end

    @anonymous_count = likes.count() - friends_count

    # render :likes_info, locals: { users: @users, friends_count: @friends_count, anonymous_count: @anonymous_count }
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
