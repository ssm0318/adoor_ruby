class AssignmentsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @assignments = Assignment.where(assignee: current_user).where.not(assigner_id: 1)
    end

    def new
        html_content = render_to_string :partial => 'assignments/default', 
            :locals => { :question => Question.find(params[:question_id]) }

        render json: {
            html_content: html_content,
        }
    end

    def create
        Assignment.create(question_id: params[:question_id], assigner_id: current_user.id, assignee_id: params[:assignee_id])

        render json: {
            assigned_user: User.find(params[:assignee_id])
        }
 
    end

    def destroy
        assignee_id = params[:assignee_id]
        question_id = params[:question_id]
        assigner_id = current_user.id
        assignment = Assignment.where(question_id: question_id, assigner_id: assigner_id, assignee_id: assignee_id)
        assignment.destroy_all

        # flash[:success] = "#{User.find(assignment.assignee_id).email}님을 de-assign하셨습니다."

        render json: {
            assigned_user: User.find(assignee_id)
        }
    end
end