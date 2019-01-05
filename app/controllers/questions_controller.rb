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
            Question.create(author_id: 1, content: csv.cell(i, 1), tag_string: csv.cell(i, 6))
        end
        render 'today'
    end

    def import_new
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        start_idx = Question.where(author_id: 1).last.id
        
        for i in start_idx..csv.last_row
            Question.create(author_id: 1, content: csv.cell(i, 1), tag_string: csv.cell(i, 2))
        end
        render 'today'
    end
end
