class AnswersController < ApplicationController
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
        check_user
    end

    def update
    end

    def destroy
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
