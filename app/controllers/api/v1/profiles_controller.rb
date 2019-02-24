class Api::V1::ProfilesController < ApplicationController
  def index
    @user = User.friendly.find(params[:id])

    if current_user == @user
        answers = Answer.where(author: current_user)
        posts = Post.where(author:current_user)
        custom_questions = CustomQuestion.where(author: current_user)
    else
        answers = @user.answers.accessible(current_user.id)
        posts = @user.posts.accessible(current_user.id)
        custom_questions = @user.custom_questions.accessible(current_user.id)
    end

    @feeds = answers + posts + custom_questions
    @feeds = @feeds.sort_by(&:created_at).reverse!

    # render :index, locals: { feeds: @feeds, user: @user }
  end

  def drawers
    @user = User.find(params[:id])
    @drawers = @user.drawers

    # render :drawers, locals: { drawers: @drawers, user: @user }
  end
end
