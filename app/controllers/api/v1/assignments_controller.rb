class Api::V1::AssignmentsController < ApplicationController
  # before_action :authenticate_user

  def new
    @question = Question.find(params[:question_id])

    render :new
  end

  def create
    Assignment.create(question_id: params[:question_id], assigner_id: current_user.id, assignee_id: params[:assignee_id])
    @assigned_user = User.find(params[:assignee_id])
    @question = Question.find(params[:question_id])

    render :create
  end

  def destroy
    assignee_id = params[:assignee_id]
    question_id = params[:question_id]
    assigner_id = current_user.id
    assignment = Assignment.where(question_id: question_id, assigner_id: assigner_id, assignee_id: assignee_id)
    assignment.destroy_all

    assigned_user = User.find(assignee_id)

    if assignment.destroy_all
      render json: {status: 'SUCCESS', message:'Deleted assignment', data: assigned_user},status: :ok
    else
      render json: {status: 'ERROR', message:'Assignment not deleted', data: assignment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

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
