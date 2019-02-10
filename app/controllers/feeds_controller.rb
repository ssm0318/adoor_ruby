class FeedsController < ApplicationController
    before_action :authenticate_user!
    
    def general
        @feeds = Answer.channel_name("익명피드").anonymous(current_user.id) + Post.channel_name("익명피드").anonymous(current_user.id) + CustomQuestion.channel_name("익명피드").anonymous(current_user.id)
        @feeds = @feeds.sort_by(&:created_at).reverse!

        # @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)
        
        render 'general'
    end
 
    def friends
        answers = Answer.accessible(current_user.id) + Answer.where(author: current_user)
        posts = Post.accessible(current_user.id) + Post.where(author:current_user)
        custom_questions = CustomQuestion.accessible(current_user.id) + CustomQuestion.where(author: current_user)
        @feeds = answers + posts + custom_questions
        @feeds = @feeds.sort_by(&:created_at).reverse!

        # @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)

        render 'friends'
    end
end
  