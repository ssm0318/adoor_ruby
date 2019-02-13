class QuestionsController < ApplicationController
    require 'roo'
    before_action :authenticate_user!, except: [:index, :today, :intro]
    before_action :set_question, only: [:show, :show_friends, :show_general]
    
    def index
        @questions = Question.published.order("selected_date DESC")
    end

    def show
        @feeds = @question.answers.accessible(current_user.id)
        @feeds += @question.answers.where(author: current_user)
        @feeds += @question.answers.channel_name("익명피드").anonymous(current_user.id)
        @feeds = @feeds.sort_by(&:created_at).reverse! 

        @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)
    end

    def today
        @questions = Question.where(selected_date: (Date.today)).shuffle
    end

    def show_friends
        @feeds = @question.answers.accessible(current_user.id)
        @feeds += @question.answers.where(author: current_user)
        @feeds = @feeds.sort_by(&:created_at).reverse!

        @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)
        
        render 'show_friends'
    end

    def show_general
        @feeds = @question.answers.channel_name("익명피드").anonymous(current_user.id).sort_by(&:created_at).reverse!

        @feeds = @feeds.paginate(:page => params[:page], :per_page => 7)
        
        render 'show_general'
    end
    
    def import_all
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        select = (1..csv.last_row).to_a.sample 5
        for i in 1..csv.last_row
            q = Question.create(content: csv.cell(i, 1), tag_string: csv.cell(i, 6))
            if !q.tag_string.nil?
                tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: 1, content: tag, target: q)
                    q.tags << new_tag
                end
            end
            if select.include? i
                q.selected_date = Date.today()
                q.save
            end
        end
        redirect_to action: "today"
    end

    def import_new
        @questions = Question.where(selected_date: (Date.today))
        csv = Roo::CSV.new('./lib/assets/questions.csv')
        start_idx = Question.last.id
        
        for i in start_idx..csv.last_row
            q = Question.create(content: csv.cell(i, 1), tag_string: csv.cell(i, 2))
            if !q.tag_string.nil?
                tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: 1, content: tag, target: q)
                    q.tags << new_tag
                end
            end
        end
        redirect_to action: "today"
    end

    private
        def set_question
            @question = Question.find(params[:id])
            if @question.selected_date.nil?
                redirect_to questions_path
            end
        end
end
