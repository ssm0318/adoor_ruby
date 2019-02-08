class SearchController < ApplicationController
    before_action :check_query

    def all
        @query = params[:query]
        Query.create(user: current_user, content: @query)

        limit = 5
        @user_results = User.where("username LIKE ? ", "%#{@query}%").order(:username)

        @question_results = Question.published.search_tag(@query).reverse
        @question_results += Question.published.where("content LIKE ? ", "%#{@query}%").reverse
        @question_results = @question_results.uniq

        @general_results = CustomQuestion.joins(:channels).where(channels: {name: "익명피드"}).search_tag(@query).reverse
        @friends_results = CustomQuestion.accessible(current_user.id).search_tag(@query).reverse
        @custom_question_results = @general_results + @friends_results
        @custom_question_results += CustomQuestion.joins(:channels).where(channels: {name: "익명피드"}).where("content LIKE ? ", "%#{@query}%").reverse
        @custom_question_results += CustomQuestion.accessible(current_user.id).where("content LIKE ? ", "%#{@query}%").reverse
        @custom_question_results = @custom_question_results.uniq(&:content)

        @more_user = @user_results.count()
        @more_question = @question_results.count()
        @more_custom = @custom_question_results.count()

        @user_results = @user_results.limit(limit)
        @question_results = @question_results.slice(0, limit)
        @custom_question_results = @custom_question_results.slice(0, limit)

        @searchpath = search_all_path

        render 'all'
    end

    def json
        # @query = params[:query]
        # Query.create(content: @query)
        # @results = []
        # @results = Answer.all.search_tag(@query) | Question.all.search_tag(@query)

        # render json: {
        #     result: @results,
        # }
    end

    def admin_question
        @query = params[:query]
        Query.create(user: current_user, content: @query)
        @results = []
        @results = Question.published.search_tag(@query).reverse
        @results += Question.published.where("content LIKE ? ", "%#{@query}%").reverse
        @results = @results.uniq


 
        render 'admin_question'
    end

    def custom_question
        @query = params[:query]
        Query.create(user: current_user, content: @query)
        @results = []
        @results = CustomQuestion.where(ancestor_id = nil).search_tag(@query).reverse
        @results += CustomQuestion.where(ancestor_id = nil).where("content LIKE ? ", "%#{@query}%").reverse
        @results = @results.uniq

        render 'custom_question'
    end

    # def friend_answer
    #     @query = params[:query]
    #     Query.create(user: current_user, content: @query)
    #     @results = []
    #     post_results = []
    #     @results = Answer.all.search_tag(@query)
    #     @results = @results.where(author: current_user.friends) | @results.where(author: current_user)
    #     post_results = Post.all.search_tag(@query)
    #     post_results = post_results.where(author: current_user.friends) | post_results.where(author: current_user)
    #     @results += post_results
    #     @results.sort_by(&:created_at).reverse!

    #     render 'friend_answer'
    # end

    # def anonymous_answer
    #     @query = params[:query]
    #     Query.create(user: current_user, content: @query)
    #     @results = []
    #     @results = Answer.all.search_tag(@query)
    #     @results = @results.anonymous(current_user.id)
    #     post_results = Post.all.search_tag(@query)
    #     post_results = post_results.anonymous(current_user.id)
    #     @results += post_results
    #     @results.sort_by(&:created_at).reverse!

    #     render 'anonymous_answer'
    # end

    def popular_tags
        @results = Tag.all.popular_tags(params[:num])
    
        render 'popular_tags'
    end

    def popular_search
        @results = Query.all.popular_search(params[:num])

        render 'popular_search'
    end

    def user
        @query = params[:query]
        UserQuery.create(user: current_user, content: @query)
        @results = User.where("username LIKE ? ", "%#{@query}%").order(:username)

        render 'user'
    end

    private

    def check_query
        if params[:query] == ""
            redirect_back fallback_location: root_url
        end
    end
end
