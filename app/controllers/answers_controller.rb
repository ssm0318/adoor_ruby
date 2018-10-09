class AnswersController < ApplicationController
    def index
        @answers = Answer.all
        render 'index'
    end

    def show
        set_answer
    end

    def user_answers
        @user = User.find(params[:id])
        @answers = @user.answers
    end

    def edit
        set_answer
    end

    def update
        set_answer
        @answer.update(answer_params)
        redirect_to @answer
    end

    def destroy
        set_answer
        @answer.destroy

        # FIXME: current_user.id로 바꾸자
        redirect_to user_answers_path(1)
    end


    private
        # use answer_params in create and update
        def answer_params
            params.require(:answer).permit(:author_id, :content, :question_id)
        end

        def set_answer
            @answer = Answer.find(params[:id])
        end
    
end