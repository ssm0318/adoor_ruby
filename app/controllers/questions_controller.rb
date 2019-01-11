class QuestionsController < ApplicationController
    require 'roo'
    before_action :authenticate_user!, except: [:index, :today, :intro]
    
    def index
        @questions = Question.all
    end

    def today
        @questions = Question.where(selected_date: (Date.today))
    end

    def question_feed
        @question = Question.find(params[:id])
        render 'question_feed'
    end

    def question_feed_friend
        @question = Question.find(params[:id])
        @answers = @question.answers.not_anonymous(current_user.id)
        render 'question_feed_friend'
    end

    def question_feed_general
        @question = Question.find(params[:id])
        @answers = @question.answers.anonymous(current_user.id)
        render 'question_feed_general'
    end
    
    def import_all
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        for i in 1..csv.last_row
            q = Question.create(author_id: 1, content: csv.cell(i, 1), tag_string: csv.cell(i, 6))
            if !q.tag_string.nil?
                tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: q.author.id, content: tag, target: q)
                    q.tags << new_tag
                end
            end
            if i <= 5
                q.selected_date = Date.today()
                q.save
            end
        end
        redirect_to action: "today"
    end

    def import_new
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        start_idx = Question.where(author_id: 1).last.id
        
        for i in start_idx..csv.last_row
            q = Question.create(author_id: 1, content: csv.cell(i, 1), tag_string: csv.cell(i, 2))
            if !q.tag_string.nil?
                tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: q.author.id, content: tag, target: q)
                    q.tags << new_tag
                end
            end
        end
        redirect_to action: "today"
    end
end
