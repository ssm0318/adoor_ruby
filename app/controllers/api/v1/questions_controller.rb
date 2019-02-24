class Api::V1::QuestionsController < ApplicationController
  require 'roo'
  before_action :authenticate_user!, except: %i[index today intro]
  before_action :set_question, only: %i[show show_friends show_general]

  def index
    @questions = Question.published.order('selected_date DESC')

    # render :questions, locals: { questions: @questions }
  end

  def show
    @feeds = @question.answers.accessible(current_user.id)
    @feeds += @question.answers.where(author: current_user)
    @feeds += @question.answers.channel_name("익명피드").anonymous(current_user.id)
    @feeds = @feeds.sort_by(&:created_at).reverse! 

    # render :show, locals: { question: @question, feeds: @feeds }
  end

  def today
    @questions = Question.where(selected_date: Date.today).shuffle

    # render :questions, locals: { questions: @questions }
  end

  def show_friends
    @feeds = @question.answers.accessible(current_user.id)
    @feeds += @question.answers.where(author: current_user)
    @feeds = @feeds.sort_by(&:created_at).reverse!

    # render :show, locals: { question: @question, feeds: @feeds }
  end

  def show_general
    @feeds = @question.answers.channel_name("익명피드").anonymous(current_user.id).sort_by(&:created_at).reverse!

    # render :show, locals: { question: @question, feeds: @feeds }
  end

  private

  def set_question
    @question = Question.find(params[:id])
    redirect_to questions_path if @question.selected_date.nil?
  end
end
