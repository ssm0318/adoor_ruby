class Api::V1::AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    question_assignments = current_user.received_assignments.where(target_type: 'Question').where.not(assigner_id: 1).order(created_at: :desc)
    @question_ids = question_assignments.pluck(:target_id).uniq
    @waiting_questions = []
    @answered_questions = []
    @question_ids.each do |q_id|
      if Answer.where(author: current_user, question: Question.find(q_id)).empty?
          @waiting_questions.push(Question.find(q_id))
      else
          @answered_questions.push(Question.find(q_id))
      end 
    end
    custom_assignments = current_user.received_assignments.where(target_type: 'CustomQuestion').order(created_at: :desc)
    @custom_question_ids = custom_assignments.pluck(:target_id).uniq

    render :index, locals: { questions: @questions, custom_questions: @custom_questions, waiting_questions: @waiting_questions, answered_questions: @answered_questions }
  end

  def new
    @question = Question.find(params[:question_id])

    render :new, locals: { question: @question }
  end 
 
  def create
    Assignment.create(target: Question.find(params[:question_id]), assigner_id: current_user.id, assignee_id: params[:assignee_id])
    @assigned_user = User.find(params[:assignee_id])
    @question = Question.find(params[:question_id])

    render :create, locals: { question: @question, assigned_user: @assigned_user }
  end 

  def destroy
    assignee_id = params[:assignee_id]
    question_id = params[:question_id]
    assigner_id = current_user.id
    assignment = Assignment.where(target: Question.find(question_id), assigner_id: assigner_id, assignee_id: assignee_id)
    assignment.destroy_all

    assigned_user = User.find(assignee_id)

    if assignment.destroy_all
      render json: {status: 'SUCCESS', message:'Deleted assignment', data: assigned_user},status: :ok
    else
      render json: {status: 'ERROR', message:'Assignment not deleted', data: assignment.errors.full_messages}, status: :unprocessable_entity
    end
  end
end
