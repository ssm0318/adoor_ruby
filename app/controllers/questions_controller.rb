class QuestionsController < ApplicationController
    # general feed?
    def index
        @questions = Question.all
        render 'index'
    end

    def question_feed
        render 'question_feed'
    end
end
