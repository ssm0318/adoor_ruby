class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = Like.create(user_id: current_user.id, target_id: params[:target_id], target_type: params[:target_type])

    # render :create, locals: { like: like }
    render json: like
  end

  def destroy
    like = Like.where(user_id: current_user.id, target_type: params[:target_type], target_id: params[:id])
    
    if like.destroy_all
      render json: { status: 'SUCCESS', message: 'Deleted like' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'like not deleted', data: like.errors.full_messages }, status: :unprocessable_entity
    end
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
