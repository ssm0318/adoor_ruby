class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friend_requests = FriendRequest.where(requestee: current_user).visible

    render :index
  end

  def create
    friend_request_hash = { requester_id: current_user.id, requestee_id: params[:id] }

    friend_request = FriendRequest.where(friend_request_hash)

    if friend_request.empty?
      @friend_request = FriendRequest.create(friend_request_hash)
    end

    render :create
  end

  def destroy
    friend_request = FriendRequest.find(params[:id])

    if friend_request.destroy
      render json: { status: 'SUCCESS', message: 'Deleted friend request' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'friend request not deleted', data: friend_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def deny
    friend_request = FriendRequest.find(params[:id])
    friend_request.invisible = true
    friend_request.save

    render :deny
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
