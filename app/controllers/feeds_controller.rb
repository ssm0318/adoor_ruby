class FeedsController < ApplicationController
    before_action :authenticate_user!
    
    def general
        @feeds = Post.anonymous(current_user.id) + Answer.anonymous(current_user.id) 
        @feeds = @feeds.sort_by(&:created_at).reverse!
        
        render 'general'
    end
 
    def friends
        
        answers = Answer.accessible(current_user.id) + Answer.where(author: current_user)
        posts = Post.accessible(current_user.id) + Post.where(author:current_user)
        @feeds = answers + posts
        @feeds = @feeds.sort_by(&:created_at).reverse!

        render 'friends'
    end
end
  