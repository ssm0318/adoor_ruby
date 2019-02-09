class FriendRequestsController < ApplicationController
    before_action :authenticate_user!

    def index
        @friend_requests = FriendRequest.where(requestee: current_user).visible
    end

    def create
        friend_request_hash = {requester_id: current_user.id, requestee_id: params[:id]}

        friend_request = FriendRequest.where(friend_request_hash)
        if friend_request.empty?
            FriendRequest.create(friend_request_hash)
        # else
        #     friend_request.destroy_all
        end
        redirect_back fallback_location: profile_path(User.find(params[:id].slug))
    end

    def destroy
        friend_request = FriendRequest.find(params[:id])
        friend_request.destroy

        redirect_back fallback_location: root_url
    end

    def deny
        friend_request = FriendRequest.find(params[:id])
        friend_request.invisible = true
        friend_request.save

        redirect_back fallback_location: friend_requests_path
    end
end
