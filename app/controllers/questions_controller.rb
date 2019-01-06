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

    def invitation
        #TODO: 질문 선택 알고리즘 어떻게? 현재는 그냥 최근질문 5개
        @questions = Question.last(5)
        render 'invitation'
    end

    def link_generation
        assigned_questions = []   # 선택된 question들을 갖고 있다 (최대 3개, 최소 0개)
        assigned_questions = Question.find(params[:q]) if params[:q]
        #FIXME: 이 부분은 deploy할 때 링크 꼭 바꿔줘야 함!! ---> https://adoor.app/....
        @link = "localhost:3000/invitation/#{current_user.id}"
        assigned_questions.each do |q|
            @link += "/" + q.id.to_s
        end
        if assigned_questions.empty?
            @link += "/" + "empty"
        end
        # now the link looks like ".../invitation/:user_id/:qid1/:qid2/:qid3" (qid's are optional)
        render 'link_generation'
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
