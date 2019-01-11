class ProfilesController < ApplicationController
    def index
        @user = User.find(params[:id])
        @feeds = @user.posts + @user.answers
        @feeds = @feeds.sort_by(&:created_at).reverse!

        render 'feeds'
    end

    def drawers
        @user = User.find(params[:id])
        @drawers = @user.drawers
    end
end 
 