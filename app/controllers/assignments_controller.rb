class AssignmentsController < ApplicationController
    before_action :authenticate_user!
    
    def create
        # question_id = params[:question_id]
        # user_id = params[:assignee_id]
        # assigned_user = User.find(user_id)

        # i=0
        # assigned_user.answers.each do |answer|
        #     puts answer.question.id
        #     if answer.question.id.to_i == question_id.to_i
        #         break
        #     end
        #     i += 1
        # end

        # if i == assigned_user.answers.count
        #     Assignment.create(question_id: question_id, assigner_id: current_user.id, assignee_id: user_id)
        #     new_assign_id = Assignment.find_by(question_id: question_id, assigner_id: current_user.id, assignee_id: user_id).id
        #     # flash[:success] = "#{assigned_user.email}님을 assign하셨습니다."
        #     # render json: {status: 'success', message: "#{assigned_user.email}님을 assign하셨습니다."}
        # else
        #     new_assign_id = "-1";
        #     # render json: {status: 'failure', message: "#{assigned_user.email}님은 이미 질문에 답하셨습니다."}
        #     # flash[:error] = "#{assigned_user.email}님은 이미 질문에 답하셨습니다."
        # end

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