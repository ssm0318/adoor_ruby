class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]
    
    def create 
        @post.new(post_params)
        @post.save

        if !@post.tag_string.nil?
            tag_array = @post.tag_string.gsub("\r\n", '\n').split('\n')
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @post)
                @post.tags << new_tag
            end
        end
       
        redirect_to root_path
    end

    def show
        @anonymous = @post.author_id != current_user.id && !(current_user.friends.include? @post.author)
    end

    def edit
        @question = @post.question
    end

    def update
        if @post.update(post_params)
            @post.tags.destroy_all

            if !@post.tag_string.nil?
                tag_array = @post.tag_string.gsub("\r\n", "\n").split("\n") 
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: @post.author.id, content: tag, target: @post)
                    @post.tags << Tag.find(new_tag.id)
                end
            end
            redirect_to @post
        else
            render 'edit'
        end
    end

    def destroy
        @post.destroy 

        redirect_to user_posts_path(current_user.id)
    end

    private
        def set_post
            @post = Post.find(params[:id])
        end

        def post_params
            params.require(:post).permit(:author_id, :content, :tag_string)
        end 

        def check_mine
            if @post.author_id != current_user.id
                redirect_to root_url
            end
        end
end
