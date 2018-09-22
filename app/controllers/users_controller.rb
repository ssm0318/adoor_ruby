class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy, :mypage]
    
    def friends
        @friends = current_user.friends
    end

    def show
    end

    def edit
    end

    def update
        @user.update(user_params)

        redirect_to show_mypage_path
    end

    def mypage
        # check_user
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
