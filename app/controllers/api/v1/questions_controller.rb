class Api::V1::QuestionsController < ApplicationController
  require 'roo'
  before_action :authenticate_user!, except: %i[index today intro]
  before_action :set_question, only: %i[show show_friends show_general]

  def index
    @questions = Question.published.order('selected_date DESC')
  end

  def show; end

  def today
    @questions = Question.where(selected_date: Date.today).shuffle
  end

  def show_friends
    @answers = @question.answers.named(current_user.id).sort_by(&:created_at).reverse!
    render 'show_friends'
  end

  def show_general
    @answers = @question.answers.anonymous(current_user.id).sort_by(&:created_at).reverse!
    render 'show_general'
  end

  def import_all
    csv = Roo::CSV.new('./lib/assets/questions.csv')
    select = (1..csv.last_row).to_a.sample 5
    (1..csv.last_row).each do |i|
      q = Question.create(content: csv.cell(i, 1), tag_string: csv.cell(i, 6))
      unless q.tag_string.nil?
        tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
        tag_array.each do |tag|
          new_tag = Tag.create(author_id: 1, content: tag, target: q)
          q.tags << new_tag
        end
      end
      if select.include? i
        q.selected_date = Date.today
        q.save
      end
    end
    redirect_to action: 'today'
  end

  def import_new
    @questions = Question.where(selected_date: Date.today)
    csv = Roo::CSV.new('./lib/assets/questions.csv')
    start_idx = Question.last.id

    (start_idx..csv.last_row).each do |i|
      q = Question.create(content: csv.cell(i, 1), tag_string: csv.cell(i, 2))
      next if q.tag_string.nil?

      tag_array = q.tag_string.gsub("\r\n", '\n').split('\n')
      tag_array.each do |tag|
        new_tag = Tag.create(author_id: 1, content: tag, target: q)
        q.tags << new_tag
      end
    end
    redirect_to action: 'today'
  end

  private

  def set_question
    @question = Question.find(params[:id])
    redirect_to questions_path if @question.selected_date.nil?
  end
end