class FeedsController < ApplicationController
    def general
        @feeds = Post.anonymous(current_user.id) + Answer.anonymous(current_user.id) 
        @feeds = @feeds.order('created_at DESC')
        
        render 'general'
    end

    def friends
        @answers = Answer.not_anonymous(current_user.id)
        @posts = Post.not_anonymous(current_user.id)
        
        render 'friends'
    end
end
 