class ProfilesController < ApplicationController
    def index
        @user = User.find(params[:id])
        @posts = @user.posts

        @user = User.find(params[:id])
        @answers = @user.answers
    end
end
