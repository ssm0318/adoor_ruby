class FeedsController < ApplicationController
    before_action :authenticate_user!
    
    def general
        @feeds = Post.anonymous(current_user.id) + Answer.anonymous(current_user.id) + CustomQuestion.anonymous(current_user.id)
        @feeds = @feeds.sort_by(&:created_at).reverse!
        
        render 'general'
    end
 
    def friends
        # 
        answers = Answer.named(current_user.id)
        posts = Post.named(current_user.id)
        custom_questions = CustomQuestion.named(current_user.id)
        @feeds = answers + posts + custom_questions
        @feeds = @feeds.sort_by(&:created_at).reverse!
        
        render 'friends'
    end
end
  