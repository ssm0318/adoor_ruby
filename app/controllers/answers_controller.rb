class AnswersController < ApplicationController
    before_action :set_answer, only: [:show]

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
        @answer = Answer.find(params[:id])
    end

    def edit
        @answer = Answer.find(params[:id])
        #TODO Question params 받아오기
        @question = Question.find(1)
    end

    def update
        @answer = Answer.find(params[:id])

        if @answer.update(answer_params)
          redirect_to @answer
        else
          render 'edit'
        end
    end

    def destroy
        @answer= Answer.find(params[:id])
        @answer.destroy  

    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content)
        end

        def check_user
            if answer.admin != current_user
                redirect_to new_user_session_path
            end
        end
end
