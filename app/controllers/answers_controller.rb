class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]

    def new
        @question = Question.find(params[:id])
        @answer = Answer.new

        render 'new'
    end
    
    def create 
        @answer = Answer.new(answer_params)
        @answer.save

        if !@answer.tag_string.nil?
            tag_array = @answer.tag_string.gsub("\r\n", '\n').split('\n')
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                @answer.tags << new_tag
            end
        end
       
        redirect_to root_path
    end

    def show
        @anonymous = @answer.author_id != current_user.id && !(current_user.friends.include? @answer.author)
    end

    def edit
        @question = @answer.question
    end

    def update
        if @answer.update(answer_params)
            @answer.tags.destroy_all

            if !@answer.tag_string.nil?
                tag_array = @answer.tag_string.gsub("\r\n", "\n").split("\n") 
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                    @answer.tags << Tag.find(new_tag.id)
                end
            end

            redirect_to @answer
        else
            render 'edit'
        end
    end

    def destroy
        @answer.destroy 
    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content, :tag_string)
        end 

        def check_mine
            if @answer.author_id != current_user.id
                redirect_to root_url
            end
        end
end
