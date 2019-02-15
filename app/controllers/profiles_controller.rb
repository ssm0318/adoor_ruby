class ProfilesController < ApplicationController
    def index
        @user = User.friendly.find(params[:id])

        if current_user == @user
            answers = Answer.where(author: current_user)
            posts = Post.where(author:current_user)
            custom_questions = CustomQuestion.where(author: current_user)
        else
            answers = @user.answers.accessible(current_user.id)
            posts = @user.posts.accessible(current_user.id)
            custom_questions = @user.custom_questions.accessible(current_user.id)
        end

        @feeds = answers + posts + custom_questions
        @feeds = @feeds.sort_by(&:created_at).reverse!

        @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)

        render 'show'
    end

    def drawers
        @user = User.friendly.find(params[:id])
        drawers = @user.drawers.sort_by(&:created_at)

        @drawers = []
        drawers.each do |drawer|
            if drawer.is_a? Question
                @drawers.push(drawer)
            else
                author = drawer.target.author
                drawer_bool = (author == current_user) || (drawer.target.channels.any? {|c| c.name == '익명피드'})
                if drawer.target.is_a? Post
                    if drawer_bool || (Post.accessible(current_user.id).exists? (drawer.target.id))
                        @drawers.push(drawer)
                    end
                elsif drawer.target.is_a? Answer
                    if drawer_bool || (Answer.accessible(current_user.id).exists? (drawer.target.id))
                        @drawers.push(drawer)
                    end
                elsif drawer.target.is_a? CustomQuestion
                    if drawer_bool || (CustomQuestion.accessible(current_user.id).exists? (drawer.target.id))
                        @drawers.push(drawer)
                    end
                end
            end
        end

        @drawers = @drawers.paginate(:page => params[:page], :per_page => 7)
    end 
end 
