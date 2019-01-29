class FeedsController < ApplicationController
    before_action :authenticate_user!
    
    def general
        @feeds = Answer.channel_name("익명피드").anonymous(current_user.id) + Post.channel_name("익명피드").anonymous(current_user.id) + CustomQuestion.channel_name("익명피드").anonymous(current_user.id)
        @feeds = @feeds.sort_by(&:created_at).reverse!
        
        render 'general'
    end
 
    def friends
        answers = Answer.accessible(current_user.id) + Answer.where(author: current_user)
        posts = Post.accessible(current_user.id) + Post.where(author:current_user)
        custom_questions = CustomQuestion.accessible(current_user.id) + CustomQuestion.where(author: current_user)
        feeds = answers + posts + custom_questions

        feeds = feeds.sort_by(&:created_at).reverse!

        @feeds = []

        feeds.each do |feed|
            if feed.is_a? Answer
                @feeds.push({
                        id: feed.id,
                        question: feed.question, 
                        channels: feed.channels, 
                        author: feed.author, 
                        content: feed.content, 
                        comments: feed.comments, 
                        likes: feed.likes,
                        drawers: feed.drawers,
                        created_at: feed.created_at})
            elsif feed.is_a? Post
                @feeds.push({
                    id: feed.id,
                    channels: feed.channels, 
                    author: feed.author, 
                    content: feed.content, 
                    comments: feed.comments, 
                    likes: feed.likes,
                    drawers: feed.drawers,
                    created_at: feed.created_at})
            else feed.is_a? CustomQuestion
                @feeds.push({
                    id: feed.id,
                    channels: feed.channels, 
                    author: feed.author, 
                    content: feed.content, 
                    comments: feed.comments, 
                    likes: feed.likes,
                    drawers: feed.drawers,
                    created_at: feed.created_at})
            end
        end

        puts '==============='
        puts @feeds[0][:id]
        render 'friends'
    end
end
  