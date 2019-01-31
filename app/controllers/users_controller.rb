require 'mini_magick'
require 'base64'

class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:recover_password, :send_temporary_password]
    before_action :set_user, only: [:show, :edit, :update, :destroy, :image_upload]
    before_action :check_user, only: [:edit, :update, :destroy]
    
    def recover_password
        render 'recover_password'
    end
    
    def send_temporary_password
        user_email = params[:email]
        UserMailer.send_temporary_password(user_email).deliver_now
        puts '======================'
        puts user_email
        # redirect_to action: 'recover_password_confirm'
        render 'recover_password_confirm'
        # 아 redirect_to 써야겠구나.... 새로고침하면 도로 recover_password 페이지로 돌아감 ㅠ
    end
   
    def friends
        #@friends = current_user.friends
        @channels = current_user.channels.drop(2)
        @friends_with_channels = []

        current_user.friends.each do |friend|
            @friends_with_channels.push({friend: friend, channels: friend.belonging_channels.where(user_id: current_user.id)})
        end

    end

    def edit
    end

    def update
        @user.update(user_params)

        if !@user.errors.full_messages.empty?
            @error = @user.errors.full_messages[0]
            render 'edit'
        else
            redirect_to profile_path(@user.id)
        end
    end

    def image_upload
        uploaded_io = params[:image]
        if uploaded_io.include? "data:image/jpeg;base64,"
            metadata = "data:image/jpeg;base64,"
            base64_string = uploaded_io[metadata.size..-1]
            image_data = Base64.decode64(base64_string)
            image = MiniMagick::Image.read(image_data)
            image.write 'image.jpeg'
            @user.image = MiniMagick::Image.open("image.jpeg")
            @user.save
        elsif uploaded_io.include? "data:image/png;base64,"
            metadata = "data:image/png;base64,"
            base64_string = uploaded_io[metadata.size..-1]
            image_data = Base64.decode64(base64_string)
            image = MiniMagick::Image.read(image_data)
            image.write 'image.png'
            @user.image = MiniMagick::Image.open("image.png")
            @user.save
        end

        redirect_back fallback_location: profile_path(params[:id])
    end

    def new_image
        render 'new_image'
    end

    def mypage
    end

    def add_friend
        friendship_hash = {user_id: current_user.id, friend_id: params[:id]}

        friendship = Friendship.where(friendship_hash)
        if friendship.empty?
            Friendship.create(friendship_hash)
            redirect_to profile_path(params[:id])
        else
            friendship.destroy_all
            Friendship.where({user_id: params[:id], friend_id: current_user.id}).destroy_all

            if(params[:from_friend_list])
                render json: {

                }
            else
                redirect_back fallback_location: profile_path(params[:id])
            end
            
        end
    end

    def friend_request
        friend_request_hash = {requester_id: current_user.id, requestee_id: params[:id]}

        friend_request = FriendRequest.where(friend_request_hash)
        if friend_request.empty?
            FriendRequest.create(friend_request_hash)
        else
            friend_request.destroy_all
        end
        redirect_back fallback_location: profile_path(params[:id])
    end

    private
        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:id, :email, :username, :image, :date_of_birth, :profile)
        end

        def image_params
            params.require(:user).permit(:image)
        end

        def check_user
            if @user != current_user
                redirect_to edit_user_profile_url(current_user.id)
            end
        end
end
