class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:recover_password, :send_temporary_password, :accept_invitation]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :check_user, only: [:edit, :update]
    
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
        @friends = current_user.friends
    end

    def edit
    end

    def update
        @user.update(user_params)

        if !@user.errors.full_messages.empty?
            @error = @user.errors.full_messages[0]
            render 'edit'
        else
            redirect_to show_mypage_path
        end
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
        #redirect_back fallback_location: user_answers_path(params[:id])
        redirect_to user_answers_path(params[:id])
    end

    def friend_request
        friend_request_hash = {requester_id: current_user.id, requestee_id: params[:id]}

        friend_request = FriendRequest.where(friend_request_hash)
        if friend_request.empty?
            FriendRequest.create(friend_request_hash)
        else
            friend_request.destroy_all
        end
        redirect_back fallback_location: user_answers_path(params[:id])
    end

    def accept_invitation
        @new_friend = User.find(params[:id])
        @assigned_questions = []
        if params[:question_id1] != "empty"
            @assigned_questions.push(Question.find(params[:question_id1])) # empty도 아니면서 question_id 가 하나도 없는 경우는 잘못된 링크이므로 이걸 걸러내기 위해
            @assigned_questions.push(Question.find(params[:question_id2])) if params[:question_id2]
            @assigned_questions.push(Question.find(params[:question_id3])) if params[:question_id3]

            if !user_signed_in?
                #session[:invitation] = request.referer
            elsif current_user.id == @new_friend.id
            elsif current_user.friends.include? @new_friend
                @assigned_questions.each do |q|
                    Assignment.find_or_create_by(question_id: q.id, assigner_id: @new_friend.id, assignee_id: current_user.id)
                end
            else
                @assigned_questions.each do |q|
                    # assigner가 admin인 assignment 만들기
                    # 이 경우 noti는 생성이 안되지만, assignment는 생성됨. 즉, assignment 모아보는 페이지에서는 이 질문들이 보임!(그럴 예정)
                    Assignment.find_or_create_by(question_id: q.id, assigner_id: 1, assignee_id: current_user.id)
                end
            end
        end
        render 'accept_invitation'
    end

    private
        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:id, :email, :username, :image, :date_of_birth)
        end

        def check_user
            if @user != current_user
                redirect_to edit_user_profile_url(current_user.id)
            end
        end
end
