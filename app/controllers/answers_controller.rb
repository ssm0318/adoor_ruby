class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]

    def new
        #TODO Question params 받아오기
        @question = Question.find(1)
        @answer = Answer.new
        render 'new'
    end
    
    def create
        @answer = Answer.new(answer_params)
        @answer.save

        redirect_to @answer
    end

    def show
    end

    def edit
    end

    def update
        if @answer.update(answer_params)
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
    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content)
        end  
end
