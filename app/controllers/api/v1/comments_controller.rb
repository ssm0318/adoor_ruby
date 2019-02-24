class Api::V1::CommentsController < ApplicationController
  def create
    secret = if params[:secret].nil?
               false
             else
               params[:secret]
             end
    @comment = Comment.create(
      content: params[:content],
      author_id: current_user.id,
      target_type: params[:target_type],
      target_id: params[:target_id],
      anonymous: params[:anonymous],
      secret: secret
    )
    @user = current_user 

    render :create, locals: { comment: @comment, user: @user }
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      render json: { status: 'SUCCESS', message: 'Deleted comment' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'comment not deleted', data: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
