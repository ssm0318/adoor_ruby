class UserMailer < ApplicationMailer
    default from: 'notification@example.com'

    def assign_email
        @user = params[:user]
        @url  = 'http://localhost:3000'
        mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    end
end
