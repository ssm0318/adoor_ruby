class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    
    def today
        
        @questions = Question.where(selected_date: (Date.today))

    end

    # before_action :authenticate_user!
    # general feed?
    def general_feed
        @questions = Question.all
        render 'general_feed'
    end

    def question_feed
        @question = Question.find(params[:id])
        render 'question_feed'
    end

    def index
        @questions = Question.all
    end
end
