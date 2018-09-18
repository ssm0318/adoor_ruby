class AssignmentsController < ApplicationController
    def create
        question_id = params[:question_id]
        user_id = params[:user_id]
        assigned_user = User.find(user_id)

        i=0
        assigned_user.answers.each do |answer|
            puts answer.question.id
            if answer.question.id.to_i == question_id.to_i
                break
            end
            i += 1
        end

        if i == assigned_user.answers.count
            Assignment.create(question_id: question_id, assigner_id: current_user.id, assignee_id: user_id)
            flash[:success] = "#{assigned_user.email}님을 assign하셨습니다."
            # render json: {status: 'success', message: "#{assigned_user.email}님을 assign하셨습니다."}
        else
            # render json: {status: 'failure', message: "#{assigned_user.email}님은 이미 질문에 답하셨습니다."}
            flash[:error] = "#{assigned_user.email}님은 이미 질문에 답하셨습니다."
        end

        redirect_to root_url

    end

    def delete
        assignment_id = params[:id]
        assignment = Assignment.find(assignment_id)
        assignment.destroy
        noti = Notification.find_by(target: assignment)
        noti.destroy

        flash[:success] = "#{User.find(assignment.assignee_id).email}님을 de-assign하셨습니다."

        redirect_to root_url
    end
end