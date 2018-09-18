class AssignmentsController < ApplicationController
    def create
        question_id = params[:question_id]
        user_id = params[:user_id]

        i=0
        User.find(user_id).answers.each do |answer|
            puts answer.question.id
            if answer.question.id.to_i == question_id.to_i
                break
            end
            i += 1
        end

        if i == User.find(user_id).answers.count
            Assignment.create(question_id: question_id, assigner_id: current_user.id, assignee_id: user_id)
        end

        redirect_to root_url
    end

    def delete
        assignment_id = params[:id]
        assignment = Assignment.find(assignment_id)
        assignment.destroy
        noti = Notification.find_by(target: assignment)
        noti.destroy

        redirect_to root_url
    end
end