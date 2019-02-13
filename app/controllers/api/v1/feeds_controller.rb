class Api::V1::FeedsController < ApplicationController
  # before_action :authenticate_user

  def general
    @feeds = Answer.channel_name('익명피드').anonymous(current_user.id) + Post.channel_name('익명피드').anonymous(current_user.id) + CustomQuestion.channel_name('익명피드').anonymous(current_user.id)
    @feeds = @feeds.sort_by(&:updated_at).reverse!

    render :feeds, locals: { feeds: @feeds }
  end

  def friends
    answers = Answer.accessible(current_user.id) + Answer.where(author: current_user)
    posts = Post.accessible(current_user.id) + Post.where(author: current_user)
    custom_questions = CustomQuestion.accessible(current_user.id) + CustomQuestion.where(author: current_user)
    @feeds = answers + posts + custom_questions
    @feeds = @feeds.sort_by(&:updated_at).reverse!

    render :feeds, locals: { feeds: @feeds }
  end

  # private 

  # def authenticate_user
  #   user_token = request.headers['X-USER-TOKEN']
  #   if user_token
  #     @user = User.find_by_token(user_token)
  #     #Unauthorize if a user object is not returned
  #     if @user.nil?
  #       return unauthorize
  #     end
  #   else
  #     return unauthorize
  #   end
  # end

  # def unauthorize
  #   head status: :unauthorized
  #   return false
  # end
end
