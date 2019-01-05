class QuestionsController < ApplicationController
    require 'roo'
    before_action :authenticate_user!, except: [:index, :today, :intro]
    
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
        @questions = Question.where.not(selected_date: nil) 
    end

    def intro
        render 'intro'
    end

    def import_all
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        for i in 1..csv.last_row
            

        render 'today'
    end

    def import_new
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
    end
end
