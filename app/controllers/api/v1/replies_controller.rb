class Api::V1::RepliesController < ApplicationController
  before_action :set_reply, only: [:destroy]

  def create
    secret = params[:secret].nil? ? false : params[:secret]
    r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id], secret: secret, anonymous: params[:anonymous], target_author_id: params[:target_author_id])

    target_author = params[:target_author_id] ? User.find(params[:target_author_id]).username : nil

    # render :create, locals: { secret: secret, target_author: target_author, user: current_user, reply: r }
  end

  def destroy
    if @reply.destroy
      render json: { status: 'SUCCESS', message: 'Deleted comment' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'comment not deleted', data: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_reply
    @reply = Reply.find(params[:id])
  end
end
