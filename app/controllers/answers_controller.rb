class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]

    def show
    end

    def user_answers
        @user = User.find(params[:id])
        @answers = @user.answers
    end

    def edit
    end

    def update
        @answer.update(answer_params)
        redirect_to @answer
    end

    def destroy
        @answer.destroy

        redirect_to user_answers_path(current_user.id)
    end

    def create_comment
        Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], answer_id: params[:id])
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