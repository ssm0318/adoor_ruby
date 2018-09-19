class UsersController < ApplicationController
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
    end
end
