class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    
    def friends
        @friends = current_user.friends
    end

    def edit
    end

    def update
        @user.update(user_params)

        redirect_to show_mypage_path
    end

    def mypage
    end

    def add_friend
        friendship_hash = {user_id: current_user.id, friend_id: params[:id]}

        friendship = Friendship.where(friendship_hash)
        if friendship.empty?
            Friendship.create(friendship_hash)
        else
            friendship.destroy_all
            Friendship.where({user_id: params[:id], friend_id: current_user.id}).destroy_all
        end
        redirect_back fallback_location: user_answers_path(params[:id])
    end

    def friend_request
        friend_request_hash = {requester_id: current_user.id, requestee_id: params[:id]}

        friend_request = FriendRequest.where(friend_request_hash)
        if friend_request.empty?
            FriendRequest.create(friend_request_hash)
        else
            friend_request.destroy_all
        end
    end

    private
        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:id, :email, :username, :profile_pic, :date_of_birth)
        end

        def check_user
            if @user != current_user
                redirect_to new_user_session_path
            end
        end
end