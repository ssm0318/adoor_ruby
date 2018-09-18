class UsersController < ApplicationController
    def recover_password
        render 'recover_password'
    end
    
    def send_temporary_password
        UserMailer.send_temporary_password
        # redirect_to action: 'index'
    end
end
