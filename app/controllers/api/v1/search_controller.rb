class Api::V1::SearchController < ApplicationController
  def all
    @query = params[:query]
    Query.create(user: current_user, content: @query)

    limit = 5
    @user_results = User.where('username LIKE ? ', "%#{@query}%").order(:username)

    @question_results = Question.published.search_tag(@query).reverse
    @question_results += Question.published.where('content LIKE ? ', "%#{@query}%").reverse
    @question_results = @question_results.uniq

    @general_results = CustomQuestion.joins(:channels).where(channels: {name: "익명피드"}).search_tag(@query).reverse
    @friends_results = CustomQuestion.accessible(current_user.id).search_tag(@query).reverse
    @custom_question_results = @general_results + @friends_results
    @custom_question_results += CustomQuestion.where(author_id: current_user.id).search_tag(@query).reverse
    @custom_question_results += CustomQuestion.joins(:channels).where(channels: {name: "익명피드"}).where("content LIKE ? ", "%#{@query}%").reverse
    @custom_question_results += CustomQuestion.accessible(current_user.id).where("content LIKE ? ", "%#{@query}%").reverse
    @custom_question_results += CustomQuestion.where(author_id: current_user.id).where("content LIKE ? ", "%#{@query}%").reverse
    @custom_question_results = @custom_question_results.uniq(&:content)

    @more_user = @user_results.count
    @more_question = @question_results.count
    @more_custom = @custom_question_results.count

    @user_results = @user_results.limit(limit)
    @question_results = @question_results.slice(0, limit)
    @custom_question_results = @custom_question_results.slice(0, limit)

    @searchpath = search_all_path

    render :results_all, locals: { 
      query: @query, 
      user_results: @user_results, 
      question_results: @question_results,
      custom_question_results: @custom_question_results,
      more_user: @more_user,
      more_question: @more_question,
      more_custom: @more_custom,
      searchpath: @searchpath 
    }
  end

  def admin_question
    @query = params[:query]
    Query.create(user: current_user, content: @query)
    @results = []
    @results = Question.published.search_tag(@query).reverse
    @results += Question.published.where('content LIKE ? ', "%#{@query}%").reverse
    @results = @results.uniq

    render :results_question, locals: { query: @query, results: @results }
  end

  def custom_question
    @query = params[:query]
    Query.create(user: current_user, content: @query)
    @results = []
    @results = CustomQuestion.where(ancestor_id = nil).search_tag(@query).reverse
    @results += CustomQuestion.where(ancestor_id = nil).where('content LIKE ? ', "%#{@query}%").reverse
    @results = @results.uniq

    render :results_custom_question, locals: { query: @query, results: @results }
  end

  def user
    @query = params[:query]
    UserQuery.create(user: current_user, content: @query)
    @results = User.where('username LIKE ? ', "%#{@query}%").order(:username)

    render :results_user, locals: { query: @query, results: @results }
  end
end
