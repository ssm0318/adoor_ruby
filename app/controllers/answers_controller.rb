class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]

    def new
        @question = Question.find(params[:id])
        @answer = Answer.new
        render 'new'
    end
    
    def create
        @answer = Answer.new(answer_params)
        @answer.save

        input_tag = @answer.tag_string
        input_tag = input_tag.gsub("\r\n", '\n')
        tag_array = input_tag.split('\n')
        tag_array.each do |tag|
            new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
            @answer.tags << new_tag
        end
       
        redirect_to @answer
    end

    def show
    end

    def edit
        @question = @answer.question
    end

    def update
        if @answer.update(answer_params)
            @answer.tags.destroy_all
            input_tag = @answer.tag_string
            input_tag = input_tag.gsub("\r\n", "\n")
            tag_array = input_tag.split("\n") 
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                @answer.tags << Tag.find(new_tag.id)
            end

            redirect_to @answer
        else
            render 'edit'
        end
    end

    def destroy
        @answer.destroy

        redirect_to user_answers_path(current_user.id)
    end

    def user_answers
        @user = User.find(params[:id])
        @answers = @user.answers
    end

    def create_comment
        Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], answer_id: params[:id])
        answer_author_id = Answer.find(params[:id]).author_id
        redirect_back fallback_location: user_answers_path(answer_author_id)
    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content, :tag_string)
        end  
end
