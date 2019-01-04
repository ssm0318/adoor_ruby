class SearchController < ApplicationController
    def all
        tag = params[:tag]
        @results = []
        @results = Answer.all.search_tag(tag) | Question.all.search_tag(tag)

        render 'all'
    end

    def admin_question
        tag = params[:tag]
        @results = []
        @results = Question.all.search_tag(tag)
        @results = @results.where(author_id: 1)

        render 'admin_question'
    end

    def custom_question
        tag = params[:tag]
        @results = []
        @results = Question.all.search_tag(tag)
        @results = @results.where.not(author_id: 1)

        render 'custom_question'
    end

    def friend_answer
        tag = params[:tag]
        @results = []
        @results = Answer.all.search_tag(tag)
        @results = @results.not_anonymous(current_user.id)

        render 'friend_answer'
    end

    def anonymous_answer
        tag = params[:tag]
        @results = []
        @results = Answer.all.search_tag(tag)
        @results = @results.anonymous(current_user.id)

        render 'anonymous_answer'
    end
end
