class QuestionsController < ApplicationController
    # before_action :authenticate_user!
    # general feed?
    def index
        @questions = Question.all
        render 'index'
    end

    def question_feed
        @question = Question.find(params[:id])
        render 'question_feed'
    end
end
